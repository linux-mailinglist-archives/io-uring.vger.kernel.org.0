Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC73614DC8E
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2020 15:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbgA3OLM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jan 2020 09:11:12 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43083 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbgA3OLL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jan 2020 09:11:11 -0500
Received: by mail-pl1-f195.google.com with SMTP id p11so1391048plq.10
        for <io-uring@vger.kernel.org>; Thu, 30 Jan 2020 06:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2qzpPATC+e//XFHkO/a46IAIi+MK7zQF06ogq1+fcAQ=;
        b=OlWpi07B3rVhxOBKyLOSbP388boSlITd3mdnW3VyiG6UeWaPmWTNzC3QKlJCHDxqnK
         q975hRIaETX5aFspjnajISJvveVk8COKg6E9VG8WS9FIkQLg23P3lmuVhSudbZz+NWIc
         n400HX0GIdDwK80OLUUk5dgB/6s9+T96MA6BtTkVFqTybDqDIghzpa+kFKoZ/Rg0CN07
         xsmSNDIwhmC9eGG7nm7GQJehtG/SKmTr9+iSsC8Zs1sVXn7SeoA7YbR20t/CwPRfZ3Z7
         a8dcBglZ8DDfeAbzcNkqIx6EnTbf0I1zR9HVAfQZfNI5RKwElKSQ4IOFzy0JaCmaKV6Q
         w0zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2qzpPATC+e//XFHkO/a46IAIi+MK7zQF06ogq1+fcAQ=;
        b=JSAGMKnZHdc9JhSQJsFBNmtX95/UZvHyE9v0Je3gPPxhx+AHYXSOG0QGuwwuMtloOD
         vXGGJ1Hh1NXsak9Lr7YHnv3AY/zljL6rz2FexBmu4irylQG3jqr+kW8vl5HALH1rhiF+
         Wj+gDCx4mKMm/kZonMFKzgwo1YUtyc0sq7FBY8Jqm4DTsTn/oXcT2EsxW5W2WxsarXZZ
         xB7wsJPkacp8olPtZQmzENQu9cnH3VUGJgW8fziaCIuTDm+Hgna5aTrEvgaTchpBRna7
         t5ZakVN7ePIWiyNvq0qX2+3bl2eEz7oScPTi6cAuSPSbYpHUQjyvWlubXYWs8Ceiskek
         JRoQ==
X-Gm-Message-State: APjAAAUVUWlHLinYX/H93d2Lezpta+JgbTyGbyFqtIfeZUziLC+VtqwI
        NlGjcJ0OuZFOtB93C9rXkuro+A==
X-Google-Smtp-Source: APXvYqz8yprW8rRd9GvKaSIYFl/xOistYpMUOTSvFe6WsK808ngEjaKwWjwTZIKW1ftnvm9Ypac7rw==
X-Received: by 2002:a17:90a:da03:: with SMTP id e3mr6263720pjv.57.1580393470571;
        Thu, 30 Jan 2020 06:11:10 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id az9sm6822811pjb.3.2020.01.30.06.11.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2020 06:11:10 -0800 (PST)
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
To:     Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>
Cc:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <CAG48ez17Ums4s=gjai-Lakr2tWf9bjmYYeNb5aGrwAD51ypZMA@mail.gmail.com>
 <4f833fc5-b4c0-c304-c3c2-f63c050b90a2@kernel.dk>
 <9ce2e571-ed84-211a-4e99-d830ecdaf0e2@kernel.dk>
 <CAG48ez1qVCoOwcdA7YZcKObQ9frWNxCjHOp6RYeqd+q_n4KJJQ@mail.gmail.com>
 <20200130102635.ar2bohr7n4li2hyd@wittgenstein>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cf801c52-7719-bb5c-c999-ab9aab0d4871@kernel.dk>
Date:   Thu, 30 Jan 2020 07:11:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200130102635.ar2bohr7n4li2hyd@wittgenstein>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/30/20 3:26 AM, Christian Brauner wrote:
> On Thu, Jan 30, 2020 at 11:11:58AM +0100, Jann Horn wrote:
>> On Thu, Jan 30, 2020 at 2:08 AM Jens Axboe <axboe@kernel.dk> wrote:
>>> On 1/29/20 10:34 AM, Jens Axboe wrote:
>>>> On 1/29/20 7:59 AM, Jann Horn wrote:
>>>>> On Tue, Jan 28, 2020 at 8:42 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>> On 1/28/20 11:04 AM, Jens Axboe wrote:
>>>>>>> On 1/28/20 10:19 AM, Jens Axboe wrote:
>>>>> [...]
>>>>>>>> #1 adds support for registering the personality of the invoking task,
>>>>>>>> and #2 adds support for IORING_OP_USE_CREDS. Right now it's limited to
>>>>>>>> just having one link, it doesn't support a chain of them.
>>>>> [...]
>>>>>> I didn't like it becoming a bit too complicated, both in terms of
>>>>>> implementation and use. And the fact that we'd have to jump through
>>>>>> hoops to make this work for a full chain.
>>>>>>
>>>>>> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
>>>>>> This makes it way easier to use. Same branch:
>>>>>>
>>>>>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs-creds
>>>>>>
>>>>>> I'd feel much better with this variant for 5.6.
>>>>>
>>>>> Some general feedback from an inspectability/debuggability perspective:
>>>>>
>>>>> At some point, it might be nice if you could add a .show_fdinfo
>>>>> handler to the io_uring_fops that makes it possible to get a rough
>>>>> overview over the state of the uring by reading /proc/$pid/fdinfo/$fd,
>>>>> just like e.g. eventfd (see eventfd_show_fdinfo()). It might be
>>>>> helpful for debugging to be able to see information about the fixed
>>>>> files and buffers that have been registered. Same for the
>>>>> personalities; that information might also be useful when someone is
>>>>> trying to figure out what privileges a running process actually has.
>>>>
>>>> Agree, that would be a very useful addition. I'll take a look at it.
>>>
>>> Jann, how much info are you looking for? Here's a rough start, just
>>> shows the number of registered files and buffers, and lists the
>>> personalities registered. We could also dump the buffer info for
>>> each of them, and ditto for the files. Not sure how much verbosity
>>> is acceptable in fdinfo?
>>
>> At the moment, I personally am just interested in this from the
>> perspective of being able to audit the state of personalities, to make
>> important information about the security state of processes visible.
>>
>> Good point about verbosity in fdinfo - I'm not sure about that myself either.
>>
>>> Here's the test app for personality:
>>
>> Oh, that was quick...
>>
>>> # cat 3
>>> pos:    0
>>> flags:  02000002
>>> mnt_id: 14
>>> user-files: 0
>>> user-bufs: 0
>>> personalities:
>>>             1: uid=0/gid=0
>>>
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index c5ca84a305d3..0b2c7d800297 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -6511,6 +6505,45 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>>>         return submitted ? submitted : ret;
>>>  }
>>>
>>> +struct ring_show_idr {
>>> +       struct io_ring_ctx *ctx;
>>> +       struct seq_file *m;
>>> +};
>>> +
>>> +static int io_uring_show_cred(int id, void *p, void *data)
>>> +{
>>> +       struct ring_show_idr *r = data;
>>> +       const struct cred *cred = p;
>>> +
>>> +       seq_printf(r->m, "\t%5d: uid=%u/gid=%u\n", id, cred->uid.val,
>>> +                                               cred->gid.val);
>>
>> As Stefan said, the ->uid and ->gid aren't very useful, since when a
>> process switches UIDs for accessing things in the filesystem, it
>> probably only changes its EUID and FSUID, not its RUID.
>> I think what's particularly relevant for uring would be the ->fsuid
>> and the ->fsgid along with ->cap_effective; and perhaps for some
>> operations also the ->euid and ->egid. The real UID/GID aren't really
>> relevant when performing normal filesystem operations and such.
> 
> This should probably just use the same format that is found in
> /proc/<pid>/status to make it easy for tools to use the same parsing
> logic and for the sake of consistency. We've adapted the same format for
> pidfds. So that would mean:
> 
> Uid:	1000	1000	1000	1000
> Gid:	1000	1000	1000	1000
> 
> Which would be: Real, effective, saved set, and filesystem {G,U}IDs
> 
> And CapEff in /proc/<pid>/status has the format:
> CapEff:	0000000000000000

I agree, consistency is good. I've added this, and also changed the
naming to be CamelCase, which is seems like most of them are. Now it
looks like this:

pos:	0
flags:	02000002
mnt_id:	14
UserFiles:     0
UserBufs:     0
Personalities:
    1
	Uid:	0		0		0		0
	Gid:	0		0		0		0
	Groups:	0
	CapEff:	0000003fffffffff

for a single personality registered (root). I have to indent it an extra
tab to display each personality.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index c5ca84a305d3..8b2411542f3e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6511,6 +6505,79 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	return submitted ? submitted : ret;
 }
 
+static int io_uring_show_cred(int id, void *p, void *data)
+{
+	const struct cred *cred = p;
+	struct seq_file *m = data;
+	struct user_namespace *uns = seq_user_ns(m);
+	struct group_info *gi;
+	kernel_cap_t cap;
+	unsigned __capi;
+	int g;
+
+	seq_printf(m, "%5d\n", id);
+	seq_put_decimal_ull(m, "\tUid:\t", from_kuid_munged(uns, cred->uid));
+	seq_put_decimal_ull(m, "\t\t", from_kuid_munged(uns, cred->euid));
+	seq_put_decimal_ull(m, "\t\t", from_kuid_munged(uns, cred->suid));
+	seq_put_decimal_ull(m, "\t\t", from_kuid_munged(uns, cred->fsuid));
+	seq_put_decimal_ull(m, "\n\tGid:\t", from_kgid_munged(uns, cred->gid));
+	seq_put_decimal_ull(m, "\t\t", from_kgid_munged(uns, cred->egid));
+	seq_put_decimal_ull(m, "\t\t", from_kgid_munged(uns, cred->sgid));
+	seq_put_decimal_ull(m, "\t\t", from_kgid_munged(uns, cred->fsgid));
+	seq_puts(m, "\n\tGroups:\t");
+	gi = cred->group_info;
+	for (g = 0; g < gi->ngroups; g++) {
+		seq_put_decimal_ull(m, g ? " " : "",
+					from_kgid_munged(uns, gi->gid[g]));
+	}
+	seq_puts(m, "\n\tCapEff:\t");
+	cap = cred->cap_effective;
+	CAP_FOR_EACH_U32(__capi)
+		seq_put_hex_ll(m, NULL, cap.cap[CAP_LAST_U32 - __capi], 8);
+	seq_putc(m, '\n');
+	return 0;
+}
+
+static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
+{
+	int i;
+
+	mutex_lock(&ctx->uring_lock);
+	seq_printf(m, "UserFiles: %5u\n", ctx->nr_user_files);
+	for (i = 0; i < ctx->nr_user_files; i++) {
+		struct fixed_file_table *table;
+		struct file *f;
+
+		table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
+		f = table->files[i & IORING_FILE_TABLE_MASK];
+		if (f)
+			seq_printf(m, "%5u: %s\n", i, file_dentry(f)->d_iname);
+		else
+			seq_printf(m, "%5u: <none>\n", i);
+	}
+	seq_printf(m, "UserBufs: %5u\n", ctx->nr_user_bufs);
+	for (i = 0; i < ctx->nr_user_bufs; i++) {
+		struct io_mapped_ubuf *buf = &ctx->user_bufs[i];
+
+		seq_printf(m, "%5u: 0x%llx/%lu\n", i, buf->ubuf, buf->len);
+	}
+	if (!idr_is_empty(&ctx->personality_idr)) {
+		seq_printf(m, "Personalities:\n");
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
@@ -6521,6 +6588,7 @@ static const struct file_operations io_uring_fops = {
 #endif
 	.poll		= io_uring_poll,
 	.fasync		= io_uring_fasync,
+	.show_fdinfo	= io_uring_show_fdinfo,
 };
 
 static int io_allocate_scq_urings(struct io_ring_ctx *ctx,

-- 
Jens Axboe

