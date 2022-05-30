Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49968537AE8
	for <lists+io-uring@lfdr.de>; Mon, 30 May 2022 14:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbiE3M5x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 May 2022 08:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236252AbiE3M5w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 May 2022 08:57:52 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1829CDF3B
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 05:57:50 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VEp4UlP_1653915468;
Received: from 30.82.254.106(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VEp4UlP_1653915468)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 30 May 2022 20:57:48 +0800
Message-ID: <5cd59dc4-23c6-f5a1-a55c-141d0d769014@linux.alibaba.com>
Date:   Mon, 30 May 2022 20:57:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH] io_uring: let IORING_OP_FILES_UPDATE support to choose
 fixed file slots
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220530124654.22349-1-xiaoguang.wang@linux.alibaba.com>
 <84974aeb-7354-6473-4c80-a1a190f80e91@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <84974aeb-7354-6473-4c80-a1a190f80e91@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.4 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

Thanks for the very quick review :)
> On 5/30/22 6:46 AM, Xiaoguang Wang wrote:
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 6d91148e9679..58514b8048da 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -5945,16 +5948,20 @@ static int io_statx(struct io_kiocb *req, unsigned int issue_flags)
>>  	return 0;
>>  }
>>  
>> +#define IORING_CLOSE_FD_AND_FILE_SLOT 1
>> +
>>  static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>  {
>> -	if (sqe->off || sqe->addr || sqe->len || sqe->rw_flags || sqe->buf_index)
>> +	if (sqe->off || sqe->addr || sqe->len || sqe->buf_index)
>>  		return -EINVAL;
>>  	if (req->flags & REQ_F_FIXED_FILE)
>>  		return -EBADF;
>>  
>>  	req->close.fd = READ_ONCE(sqe->fd);
>>  	req->close.file_slot = READ_ONCE(sqe->file_index);
>> -	if (req->close.file_slot && req->close.fd)
>> +	req->close.flags = READ_ONCE(sqe->close_flags);
> This needs a:
>
> 	if (req->closeflags & ~IORING_CLOSE_FD_AND_FILE_SLOT)
> 		return -EINVAL;
>
> to be future proof in terms of new flags.
OK.

>
>> +	if (!(req->close.flags & IORING_CLOSE_FD_AND_FILE_SLOT) &&
>> +	    req->close.file_slot && req->close.fd)
>>  		return -EINVAL;
>>  
>>  	return 0;
>> @@ -5970,7 +5977,8 @@ static int io_close(struct io_kiocb *req, unsigned int issue_flags)
>>  
>>  	if (req->close.file_slot) {
>>  		ret = io_close_fixed(req, issue_flags);
>> -		goto err;
>> +		if (ret || !(req->close.flags & IORING_CLOSE_FD_AND_FILE_SLOT))
>> +			goto err;
>>  	}
>>  
>>  	spin_lock(&files->file_lock);
>> @@ -8003,23 +8011,63 @@ static int io_files_update_prep(struct io_kiocb *req,
>>  	return 0;
>>  }
>>  
>> +static int io_files_update_with_index_alloc(struct io_kiocb *req,
>> +					    unsigned int issue_flags)
>> +{
>> +	__s32 __user *fds = u64_to_user_ptr(req->rsrc_update.arg);
>> +	struct file *file;
>> +	unsigned int done, nr_fds = req->rsrc_update.nr_args;
>> +	int ret, fd;
>> +
>> +	for (done = 0; done < nr_fds; done++) {
>> +		if (copy_from_user(&fd, &fds[done], sizeof(fd))) {
>> +			ret = -EFAULT;
>> +			break;
>> +		}
>> +
>> +		file = fget(fd);
>> +		if (!file) {
>> +			ret = -EBADF;
>> +			goto out;
>> +		}
>> +		ret = io_fixed_fd_install(req, issue_flags, file,
>> +					  IORING_FILE_INDEX_ALLOC);
>> +		if (ret < 0)
>> +			goto out;
>> +		if (copy_to_user(&fds[done], &ret, sizeof(ret))) {
>> +			ret = -EFAULT;
>> +			__io_close_fixed(req, issue_flags, ret);
>> +			break;
>> +		}
>> +	}
>> +
>> +out:
>> +	if (done)
>> +		return done;
>> +	return ret;
>> +}
>> +
>>  static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
>>  {
>>  	struct io_ring_ctx *ctx = req->ctx;
>>  	struct io_uring_rsrc_update2 up;
>>  	int ret;
>>  
>> -	up.offset = req->rsrc_update.offset;
>> -	up.data = req->rsrc_update.arg;
>> -	up.nr = 0;
>> -	up.tags = 0;
>> -	up.resv = 0;
>> -	up.resv2 = 0;
>> +	if (req->rsrc_update.offset == IORING_FILE_INDEX_ALLOC) {
>> +		ret = io_files_update_with_index_alloc(req, issue_flags);
>> +	} else {
>> +		up.offset = req->rsrc_update.offset;
>> +		up.data = req->rsrc_update.arg;
>> +		up.nr = 0;
>> +		up.tags = 0;
>> +		up.resv = 0;
>> +		up.resv2 = 0;
> Move 'up' into this branch?
OK.

>
> Do you have a liburing test case for this as well?
Yeah, just sent it.

Regards,
Xiaoguang Wang
>

