Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28687500A4
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 10:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjGLIDI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 04:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbjGLICU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 04:02:20 -0400
Received: from out-59.mta0.migadu.com (out-59.mta0.migadu.com [IPv6:2001:41d0:1004:224b::3b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CAA1FC7
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 01:01:17 -0700 (PDT)
Message-ID: <95e2b151-ac0e-b0f6-567f-9bc9a802e0da@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689148867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6yj6XybnIwDjNgThNnuY+kBs95bcm6g2Kc+E77PmFOY=;
        b=Y9y/MEH6IoMOYMAlPSeWdpieOMU1x+VwYG4N3g+CfS1IvMxlZEKvxBzK0pLTZyygyh88OP
        acLZ4OqH/4zTqF34Cbw10Q3sGAnkYii7geNQy19bg7zxtS80KM6yKW5ty6LEgrN/ARgB6U
        zxgxGrNVYIAzyLwIWwg/dCd5l8X1N3Q=
Date:   Wed, 12 Jul 2023 16:01:00 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] io_uring: add support for getdents
Content-Language: en-US
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
References: <20230711114027.59945-1-hao.xu@linux.dev>
 <20230711114027.59945-4-hao.xu@linux.dev> <ZK1H568bvIzcsB6J@codewreck.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <ZK1H568bvIzcsB6J@codewreck.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/11/23 20:15, Dominique Martinet wrote:
> Hao Xu wrote on Tue, Jul 11, 2023 at 07:40:27PM +0800:
>> diff --git a/io_uring/fs.c b/io_uring/fs.c
>> index f6a69a549fd4..77f00577e09c 100644
>> --- a/io_uring/fs.c
>> +++ b/io_uring/fs.c
>> @@ -291,3 +298,56 @@ void io_link_cleanup(struct io_kiocb *req)
>>   	putname(sl->oldpath);
>>   	putname(sl->newpath);
>>   }
>> +
>> +int io_getdents_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>> +{
>> +	struct io_getdents *gd = io_kiocb_to_cmd(req, struct io_getdents);
>> +
>> +	if (READ_ONCE(sqe->off) != 0)
>> +		return -EINVAL;
>> +
>> +	gd->dirent = u64_to_user_ptr(READ_ONCE(sqe->addr));
>> +	gd->count = READ_ONCE(sqe->len);
>> +
>> +	return 0;
>> +}
>> +
>> +int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
>> +{
>> +	struct io_getdents *gd = io_kiocb_to_cmd(req, struct io_getdents);
>> +	struct file *file;
>> +	unsigned long getdents_flags = 0;
>> +	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>> +	bool should_lock = false;
>> +	int ret;
>> +
>> +	if (force_nonblock) {
>> +		if (!(req->file->f_mode & FMODE_NOWAIT))
>> +			return -EAGAIN;
>> +
>> +		getdents_flags = DIR_CONTEXT_F_NOWAIT;
>> +	}
>> +
>> +	file = req->file;
>> +	if (file && (file->f_mode & FMODE_ATOMIC_POS)) {
> 
> If file is NULL here things will just blow up in vfs_getdents anyway,
> let's remove the useless check

Sorry, forgot this one. Actually I think the file NULL check is not 
necessary here since it has been done in general code path in 
io_assign_file()


> 
>> +		if (file_count(file) > 1)
> 
> I was curious about this so I found it's basically what __fdget_pos does
> before deciding it should take the f_pos_lock, and as such this is
> probably correct... But if someone can chime in here: what guarantees
> someone else won't __fdget_pos (or equivalent through this) the file
> again between this and the vfs_getdents call?
> That second get would make file_count > 1 and it would lock, but lock
> hadn't been taken here so the other call could get the lock without
> waiting and both would process getdents or seek or whatever in
> parallel.
> 
> 
> That aside I don't see any obvious problem with this.
> 

