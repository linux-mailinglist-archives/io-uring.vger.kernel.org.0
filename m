Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAA2814D534
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2020 03:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgA3CU4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 21:20:56 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45095 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbgA3CU4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 21:20:56 -0500
Received: by mail-pf1-f194.google.com with SMTP id 2so645195pfg.12
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2020 18:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j+mbt354IvM+HVLExpoovPNr4ZDE/RsEGE1VDU+FSyQ=;
        b=ydcPSWSpZ6OPpk0C8n5ZLSEpkC0DWeScCKcR2iWn7J+yxHY3lyHget2Uhp60sn4wgh
         CPOOA0M/kNt0Y9AvYtAAcIa2BULQrOaqnpwvGuILHS/Gy0V9dlI6S3AQGQK7kBeguf/2
         UPjfyQx1p27mKS+iUxPFiCBLcUywfbGTC/whgolyu6YMZXwVEpiwRLWDLYbZ13uVbSe9
         uF92UtncnrmZridzJ+AkeB4zIhLdsv0RijV3S8GeO1inEHsnOuvFJ4yWg72iB5eSlgMy
         qB9oxyCvBXFHsZZWJtZqD1kRqySNAbiSBE6KATtoy6GIqz4QTreaUh9uhNls6YD/rkp0
         lKnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j+mbt354IvM+HVLExpoovPNr4ZDE/RsEGE1VDU+FSyQ=;
        b=THGy14sEgPmKqTh03HEe2sJzzU8XbXSH0w7tHHs2I2/SXA6DHzWI8kSKAP+xLLDGr+
         diIsfXH3HJfSIKxOx8BJ6xvwkee6G48NtuQlCFl4tcyw/tmTm9oa6ylIdk7R8Oz8qB7M
         gTS9oBTkiJbvphHLSZ/ylZ6bops//5aroyqpvO+zF10UMdAAj92XUpKcqBLza+4FsdR0
         iWJV+kfukMStXHBqbYyzuw5GmQyWzCGg8nlvjwlHfAw2l374pbBS2Rc3MBzKuINRx47O
         A+kTFg8Dh4YVDqm1xuUhy8NLCY9Z6P5KLoFpXN9zGAUBlNpmNZSt7CckUvfRcAIzwsnM
         LMpA==
X-Gm-Message-State: APjAAAWc7Gi4ZKLvWidiTNuVQFs+I6hvqhLDoAFHVz1vUdZWwawdTHr1
        zOfGoKpGQ9+WO3bOeTwQk7RCSQ==
X-Google-Smtp-Source: APXvYqxvCwLuW0S8qJ2jX2YktHuqi78ElcCJaZnYR41oJQXCbN4bQ4qhQBG9bLiJ4jv22yZFNGIUpw==
X-Received: by 2002:a63:b141:: with SMTP id g1mr2392756pgp.168.1580350854909;
        Wed, 29 Jan 2020 18:20:54 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id y16sm3843036pgf.41.2020.01.29.18.20.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 18:20:54 -0800 (PST)
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
From:   Jens Axboe <axboe@kernel.dk>
To:     Jann Horn <jannh@google.com>
Cc:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <CAG48ez17Ums4s=gjai-Lakr2tWf9bjmYYeNb5aGrwAD51ypZMA@mail.gmail.com>
 <4f833fc5-b4c0-c304-c3c2-f63c050b90a2@kernel.dk>
 <9ce2e571-ed84-211a-4e99-d830ecdaf0e2@kernel.dk>
Message-ID: <6372aa92-6b28-4a5f-ca6d-7741e1c8592e@kernel.dk>
Date:   Wed, 29 Jan 2020 19:20:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <9ce2e571-ed84-211a-4e99-d830ecdaf0e2@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/29/20 6:08 PM, Jens Axboe wrote:
> On 1/29/20 10:34 AM, Jens Axboe wrote:
>> On 1/29/20 7:59 AM, Jann Horn wrote:
>>> On Tue, Jan 28, 2020 at 8:42 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 1/28/20 11:04 AM, Jens Axboe wrote:
>>>>> On 1/28/20 10:19 AM, Jens Axboe wrote:
>>> [...]
>>>>>> #1 adds support for registering the personality of the invoking task,
>>>>>> and #2 adds support for IORING_OP_USE_CREDS. Right now it's limited to
>>>>>> just having one link, it doesn't support a chain of them.
>>> [...]
>>>> I didn't like it becoming a bit too complicated, both in terms of
>>>> implementation and use. And the fact that we'd have to jump through
>>>> hoops to make this work for a full chain.
>>>>
>>>> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
>>>> This makes it way easier to use. Same branch:
>>>>
>>>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs-creds
>>>>
>>>> I'd feel much better with this variant for 5.6.
>>>
>>> Some general feedback from an inspectability/debuggability perspective:
>>>
>>> At some point, it might be nice if you could add a .show_fdinfo
>>> handler to the io_uring_fops that makes it possible to get a rough
>>> overview over the state of the uring by reading /proc/$pid/fdinfo/$fd,
>>> just like e.g. eventfd (see eventfd_show_fdinfo()). It might be
>>> helpful for debugging to be able to see information about the fixed
>>> files and buffers that have been registered. Same for the
>>> personalities; that information might also be useful when someone is
>>> trying to figure out what privileges a running process actually has.
>>
>> Agree, that would be a very useful addition. I'll take a look at it.
> 
> Jann, how much info are you looking for? Here's a rough start, just
> shows the number of registered files and buffers, and lists the
> personalities registered. We could also dump the buffer info for
> each of them, and ditto for the files. Not sure how much verbosity
> is acceptable in fdinfo?
> 
> Here's the test app for personality:
> 
> # cat 3
> pos:	0
> flags:	02000002
> mnt_id:	14
> user-files: 0
> user-bufs: 0
> personalities:
> 	    1: uid=0/gid=0

Here's one that adds the registered buffers and files as well. So
essentially this shows any info on the registered parts.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index c5ca84a305d3..e306691bc7a4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6511,6 +6505,55 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	return submitted ? submitted : ret;
 }
 
+static int io_uring_show_cred(int id, void *p, void *data)
+{
+	const struct cred *cred = p;
+	struct seq_file *m = data;
+
+	seq_printf(m, "%5d: uid=%u/gid=%u\n", id, cred->uid.val, cred->gid.val);
+	return 0;
+}
+
+static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
+{
+	int i;
+
+	mutex_lock(&ctx->uring_lock);
+	seq_printf(m, "user-files: %d\n", ctx->nr_user_files);
+	for (i = 0; i < ctx->nr_user_files; i++) {
+		struct fixed_file_table *table;
+		struct file *f;
+
+		table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
+		f = table->files[i & IORING_FILE_TABLE_MASK];
+		if (f)
+			seq_printf(m, "%5d: %s\n", i, file_dentry(f)->d_iname);
+		else
+			seq_printf(m, "%5d: <none>\n", i);
+	}
+	seq_printf(m, "user-bufs: %d\n", ctx->nr_user_bufs);
+	for (i = 0; i < ctx->nr_user_bufs; i++) {
+		struct io_mapped_ubuf *buf = &ctx->user_bufs[i];
+
+		seq_printf(m, "%5d: 0x%llx/%lu\n", i, buf->ubuf, buf->len);
+	}
+	if (!idr_is_empty(&ctx->personality_idr)) {
+		seq_printf(m, "personalities:\n");
+		idr_for_each(&ctx->personality_idr, io_uring_show_cred, m);
+	}
+	mutex_unlock(&ctx->uring_lock);
+}
+
+static void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	struct io_ring_ctx *ctx = f->private_data;
+
+	if (percpu_ref_tryget(&ctx->refs)) {
+		__io_uring_show_fdinfo(ctx, m);
+		percpu_ref_put(&ctx->refs);
+	}
+}
+
 static const struct file_operations io_uring_fops = {
 	.release	= io_uring_release,
 	.flush		= io_uring_flush,
@@ -6521,6 +6564,7 @@ static const struct file_operations io_uring_fops = {
 #endif
 	.poll		= io_uring_poll,
 	.fasync		= io_uring_fasync,
+	.show_fdinfo	= io_uring_show_fdinfo,
 };
 
 static int io_allocate_scq_urings(struct io_ring_ctx *ctx,

-- 
Jens Axboe

