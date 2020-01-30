Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3FE914D4EB
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2020 02:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgA3BIE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 20:08:04 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39256 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727078AbgA3BIE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 20:08:04 -0500
Received: by mail-pl1-f196.google.com with SMTP id g6so655805plp.6
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2020 17:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hneFzkKNJzsnXUPpmKU4iGA3NcgrRxgGLb9aeepaBic=;
        b=WQZKsdyqKWmSKnsa92x5oVGBJmaqy8JEiELGGAFlpvKqgxbXnA/0F8NNGwmu2zKu/R
         KnQlI3Yk0qAioEJv0fw29rRv73bh/CvW7ldYw9Xh2jqixbzGlwLKea1jsDbkxGKqEJsI
         F9o2M0fddKINKrQhfK6591PUgIt0ivwAHNE/d5FvI6UOlKyVSpVL015CtbfGvwSzf603
         Rg0p5BofsQCKgp3yheg4fJRWBnO/ANW6CHHpXqHPM6SEFfHphW7lDyPY+k+WbqHJzuyC
         K+8wIhUnel6/GEsioFpoVyX+bEUU/AW1tg3vBXgLcwvAhEKHG2TyZ+VEE3PV6pcp+59R
         JynQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hneFzkKNJzsnXUPpmKU4iGA3NcgrRxgGLb9aeepaBic=;
        b=DrijZGNEe9tbUX1bW3SVoWvk4DyQpTVoZ4rSNwwPIhKjkbcwcF0/vjYLKP5DdCdK0U
         AlYGe4npcUiJUmK30wIflQnLNR4s+v1ftxwvuQfgm7TBq+Di77VGZHl2medj3rjKfnS5
         DkaqprChJoC9M1coxQUuKQKILFlVRJdJ/Lqqra4GH05sHSdjDYsNMW9lQjPLrDtv/ZSW
         gw/reOnMx/LYUQxLY/6WhYZXzz0DdFeqMCFZ+MwN0IBq+AalRzATedYmZNWiI/vXtdfp
         W4BJxwm/J9ktQmrHEJBkOwe/irQ2u/Vexon8KqsQyE9R1YMUjpY4bc7boLzD+4QLVwFF
         poUA==
X-Gm-Message-State: APjAAAUs4s4chMBDn5Nu1ULr0jdrt8I8AuUmekCQD9qR213gRKsJz2/d
        2A+m4xD7jnbWwUHPMjdLuL//jg==
X-Google-Smtp-Source: APXvYqxSFRUhalonT5kIaUtb5aWxxFo63olE32/a7JBZJrs0IIs1ZWuGQJjod9RfXd6+pCmfBVdoWQ==
X-Received: by 2002:a17:90a:9f83:: with SMTP id o3mr2832727pjp.95.1580346483049;
        Wed, 29 Jan 2020 17:08:03 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id x21sm3859447pfn.164.2020.01.29.17.08.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 17:08:02 -0800 (PST)
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
Message-ID: <9ce2e571-ed84-211a-4e99-d830ecdaf0e2@kernel.dk>
Date:   Wed, 29 Jan 2020 18:08:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <4f833fc5-b4c0-c304-c3c2-f63c050b90a2@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/29/20 10:34 AM, Jens Axboe wrote:
> On 1/29/20 7:59 AM, Jann Horn wrote:
>> On Tue, Jan 28, 2020 at 8:42 PM Jens Axboe <axboe@kernel.dk> wrote:
>>> On 1/28/20 11:04 AM, Jens Axboe wrote:
>>>> On 1/28/20 10:19 AM, Jens Axboe wrote:
>> [...]
>>>>> #1 adds support for registering the personality of the invoking task,
>>>>> and #2 adds support for IORING_OP_USE_CREDS. Right now it's limited to
>>>>> just having one link, it doesn't support a chain of them.
>> [...]
>>> I didn't like it becoming a bit too complicated, both in terms of
>>> implementation and use. And the fact that we'd have to jump through
>>> hoops to make this work for a full chain.
>>>
>>> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
>>> This makes it way easier to use. Same branch:
>>>
>>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs-creds
>>>
>>> I'd feel much better with this variant for 5.6.
>>
>> Some general feedback from an inspectability/debuggability perspective:
>>
>> At some point, it might be nice if you could add a .show_fdinfo
>> handler to the io_uring_fops that makes it possible to get a rough
>> overview over the state of the uring by reading /proc/$pid/fdinfo/$fd,
>> just like e.g. eventfd (see eventfd_show_fdinfo()). It might be
>> helpful for debugging to be able to see information about the fixed
>> files and buffers that have been registered. Same for the
>> personalities; that information might also be useful when someone is
>> trying to figure out what privileges a running process actually has.
> 
> Agree, that would be a very useful addition. I'll take a look at it.

Jann, how much info are you looking for? Here's a rough start, just
shows the number of registered files and buffers, and lists the
personalities registered. We could also dump the buffer info for
each of them, and ditto for the files. Not sure how much verbosity
is acceptable in fdinfo?

Here's the test app for personality:

# cat 3
pos:	0
flags:	02000002
mnt_id:	14
user-files: 0
user-bufs: 0
personalities:
	    1: uid=0/gid=0


diff --git a/fs/io_uring.c b/fs/io_uring.c
index c5ca84a305d3..0b2c7d800297 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6511,6 +6505,45 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	return submitted ? submitted : ret;
 }
 
+struct ring_show_idr {
+	struct io_ring_ctx *ctx;
+	struct seq_file *m;
+};
+
+static int io_uring_show_cred(int id, void *p, void *data)
+{
+	struct ring_show_idr *r = data;
+	const struct cred *cred = p;
+
+	seq_printf(r->m, "\t%5d: uid=%u/gid=%u\n", id, cred->uid.val,
+						cred->gid.val);
+	return 0;
+}
+
+static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
+{
+	struct ring_show_idr r = { .ctx = ctx, .m = m };
+
+	mutex_lock(&ctx->uring_lock);
+	seq_printf(m, "user-files: %d\n", ctx->nr_user_files);
+	seq_printf(m, "user-bufs: %d\n", ctx->nr_user_bufs);
+	if (!idr_is_empty(&ctx->personality_idr)) {
+		seq_printf(m, "personalities:\n");
+		idr_for_each(&ctx->personality_idr, io_uring_show_cred, &r);
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
@@ -6521,6 +6554,7 @@ static const struct file_operations io_uring_fops = {
 #endif
 	.poll		= io_uring_poll,
 	.fasync		= io_uring_fasync,
+	.show_fdinfo	= io_uring_show_fdinfo,
 };
 
 static int io_allocate_scq_urings(struct io_ring_ctx *ctx,

-- 
Jens Axboe

