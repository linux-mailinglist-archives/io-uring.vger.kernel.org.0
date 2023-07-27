Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D047653DC
	for <lists+io-uring@lfdr.de>; Thu, 27 Jul 2023 14:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbjG0M2c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Jul 2023 08:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234319AbjG0M16 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Jul 2023 08:27:58 -0400
Received: from out-71.mta1.migadu.com (out-71.mta1.migadu.com [95.215.58.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5401030EB
        for <io-uring@vger.kernel.org>; Thu, 27 Jul 2023 05:27:18 -0700 (PDT)
Message-ID: <34f3b7ce-41f1-49c8-781d-a73b48481e0d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690460815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=exoCYtqs4lKqJRylVtrIZXW7kCXNeNEVdEMQ+pCJcHg=;
        b=BaqiPSAGVUuwX0RzK5qjvyw4xGjFXILgA4tzmXVsCDqGuG2yDXTXng8OfXu70jiSpl2Mc1
        l+UYs0hvUrCoAMLSZK0qtW1qy1hp+Y8fQwHrSCGAJ3Okgh3TApfTYgNiXHl959CtqR9FKw
        dBf3wUP4UuwUyt1jj8JZqQYVznhkBBc=
Date:   Thu, 27 Jul 2023 20:26:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 5/7] add llseek_nowait support for xfs
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
References: <20230726102603.155522-1-hao.xu@linux.dev>
 <20230726102603.155522-6-hao.xu@linux.dev>
 <ZMGaqsDTe4oDCdAZ@dread.disaster.area>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <ZMGaqsDTe4oDCdAZ@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/27/23 06:14, Dave Chinner wrote:
> On Wed, Jul 26, 2023 at 06:26:01PM +0800, Hao Xu wrote:
>> From: Hao Xu <howeyxu@tencent.com>
>>
>> Add llseek_nowait() operation for xfs, it acts just like llseek(). The
>> thing different is it delivers nowait parameter to iomap layer.
>>
>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>> ---
>>   fs/xfs/xfs_file.c | 29 +++++++++++++++++++++++++++--
>>   1 file changed, 27 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index 73adc0aee2ff..cba82264221d 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -1257,10 +1257,11 @@ xfs_file_readdir(
>>   }
>>   
>>   STATIC loff_t
>> -xfs_file_llseek(
>> +__xfs_file_llseek(
>>   	struct file	*file,
>>   	loff_t		offset,
>> -	int		whence)
>> +	int		whence,
>> +	bool		nowait)
>>   {
>>   	struct inode		*inode = file->f_mapping->host;
>>   
>> @@ -1282,6 +1283,28 @@ xfs_file_llseek(
>>   	return vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
>>   }
>>   
>> +STATIC loff_t
>> +xfs_file_llseek(
>> +	struct file	*file,
>> +	loff_t		offset,
>> +	int		whence)
>> +{
>> +	return __xfs_file_llseek(file, offset, whence, false);
>> +}
>> +
>> +STATIC loff_t
>> +xfs_file_llseek_nowait(
>> +	struct file	*file,
>> +	loff_t		offset,
>> +	int		whence,
>> +	bool		nowait)
>> +{
>> +	if (file->f_op == &xfs_file_operations)
>> +		return __xfs_file_llseek(file, offset, whence, nowait);
>> +	else
>> +		return generic_file_llseek(file, offset, whence);
>> +}
>> +
>>   #ifdef CONFIG_FS_DAX
>>   static inline vm_fault_t
>>   xfs_dax_fault(
>> @@ -1442,6 +1465,7 @@ xfs_file_mmap(
>>   
>>   const struct file_operations xfs_file_operations = {
>>   	.llseek		= xfs_file_llseek,
>> +	.llseek_nowait	= xfs_file_llseek_nowait,
>>   	.read_iter	= xfs_file_read_iter,
>>   	.write_iter	= xfs_file_write_iter,
>>   	.splice_read	= xfs_file_splice_read,
>> @@ -1467,6 +1491,7 @@ const struct file_operations xfs_dir_file_operations = {
>>   	.read		= generic_read_dir,
>>   	.iterate_shared	= xfs_file_readdir,
>>   	.llseek		= generic_file_llseek,
>> +	.llseek_nowait	= xfs_file_llseek_nowait,
>>   	.unlocked_ioctl	= xfs_file_ioctl,
>>   #ifdef CONFIG_COMPAT
>>   	.compat_ioctl	= xfs_file_compat_ioctl,
> 
> This is pretty nasty. It would be far better just to change the
> .llseek method than to inflict this on every filesystem for the
> forseeable future.
> 
> Not that I'm a fan of passing "nowait" booleans all through the file
> operations methods - that way lies madness. We use a control
> structure for the IO path operations (kiocb) to hold per-call
> context information, perhaps we need something similar for these
> other methods that people are wanting to hook up to io_uring (e.g.
> readdir) so taht we don't have to play whack-a-mole with every new
> io_uring method that people want and then end up with a different
> nowait solution for every method.
> 
> -Dave.

whack-a-mole is exactly what I thought when I tried to find a place to
hold that...I'll think about it in next version, a generic structure for
io_uring is good I believe. I'll update this patchset after the getdents
stuff are merged.

Thanks,
Hao
