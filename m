Return-Path: <io-uring+bounces-5158-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 594299DEF3A
	for <lists+io-uring@lfdr.de>; Sat, 30 Nov 2024 08:24:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C5FC281705
	for <lists+io-uring@lfdr.de>; Sat, 30 Nov 2024 07:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D719013C83D;
	Sat, 30 Nov 2024 07:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tdtb471O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FBA3F9C5
	for <io-uring@vger.kernel.org>; Sat, 30 Nov 2024 07:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732951455; cv=none; b=ouiLf/7Zc7VbWxlJs6tosOfcKG73tBlHdIIUdUTflghlgN1ba3nS8MYtq080s2LoIw3c/oH76rUYTENinFToQiQdGhcQe52VcpkXuzJp1mbcSL9D8EZxLtS8fGgk/0X2GN/LkxpBIc8yGQ9jw+M7CDe+Z48PSAHD4ThwHNwhyzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732951455; c=relaxed/simple;
	bh=ZuGzMu1cAhdhKnxWmpQYt48/+C2Q2jjl167J8oEkP9k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IjXNBcuXqY8vyhxoyMQnpRVWsqNrKKWYUlVYsonj4aNQ5dlSv/njCO0xJdsFmPgAy7GHaTrJGunV50YfJBSwFlbfAghYqNQk0fWDsm+8VKidv58AWj317VGczA6jXtWqjmnmr4m0HPKczKoBrCq+4H1VppEg6/Pfk+MeeiUb5zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tdtb471O; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5cfddb70965so2985941a12.0
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 23:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1732951452; x=1733556252; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SjT13Cv4AdQa2fEkQJmI8w/5/0E5OcwQAJoY5vQggB4=;
        b=Tdtb471OzkffiZ2kKkvkB5J1US2IbqU5UDbmbJJgJpD3snnQ9mokYYmKI3UlSbUYp+
         w31dG39iiVLF7+YxiKjZclFvN23p7AyiHUIKUSPVBdYyiWtdIHMMcEc3zuL8h9+Hep7a
         pTBo0zBv/KuB9ua3dN/SC0eZhEYlceeS+wmLs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732951452; x=1733556252;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SjT13Cv4AdQa2fEkQJmI8w/5/0E5OcwQAJoY5vQggB4=;
        b=GAqKu7NAiar3enkGo1owpnEQ2JznizZG0qV+zCLlPpUW1IROo/Jv47xxIOd/Jr0IL/
         E/+JNpisKH3+iu/dDOamMl12jznncR6YBIWM/aX6CVWIffpgmUAHoF/TEqpjOGvekw68
         Vf+5V+pavMc+GYgLvhUuD9uqiJeCMEcKpMupMaBX01W8QrPw1MmI8LjE0nDN6L36CglR
         XIGoB3eaHr8jKw4pmyLkppsrJoSrtMZv/QuTaZMcyvVpCj/7EM+3S28gBu9LOGRj8Z3O
         k63R0qd0vUnMTjRxQFhgdfNcsNCuJ6byvzt6nG0KvLMjSQWmf40hIkMaMiJB+Jj2gkm/
         aWYA==
X-Forwarded-Encrypted: i=1; AJvYcCWQa7Ou+ztn/1vVpXMDeXDWeHDN6IobcawG3ZosO4U9rtV4Dk5jQYJf8FRhIbAp7rzeRdyKXHFEJQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwITd5LOlz8S9iCddLxCkdTEu13OfxzCsPQf043GrLwSaVBuFmC
	zKzKCLUYdfZY/xD7v94MuecUq7V8iFIZj9L6are9eJUuekZDGb37bOOKe4CtNqrm5B633TncUIp
	cGqIiMQ==
X-Gm-Gg: ASbGncsnwgWuGKfuJeG2HFQXbYPZAI8L6rYjQY3UXbtzhd8VsF/YILnv9EIYmSZnS9L
	vNGyc6V+CD6EIDxacXh8D2SWygqBtY4fft9pNjbNwQMlDc0/bPx8AgqnTVrlmLv8peSpwaSnd9X
	zTGcoRN5j0+cHSwdg9U+F8PDDcFFMszUwdEN4WIKyD1Y7/TwbFp8Yyf2UYCsbpSMrRekVW70KiT
	JrwYKx0KbKFxx21qI+L7plQvJh44ex631BFiGRFePaiEMVDO9TO2Ll9g5LnFv3ttO/msK4DwV9H
	e5aYeF54Dj59wQbToVeXVGCY
X-Google-Smtp-Source: AGHT+IHXpS6VfqLLS9tkoAH6vsJVkvbirVP9zApcWdEhuh5FbvepZZJenqFbx+d6utIyRB0WhuF9mw==
X-Received: by 2002:a17:907:7637:b0:aa5:4adc:5a1f with SMTP id a640c23a62f3a-aa580f58e93mr1127366066b.33.1732951451846;
        Fri, 29 Nov 2024 23:24:11 -0800 (PST)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com. [209.85.128.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996de56dsm251696566b.79.2024.11.29.23.24.09
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Nov 2024 23:24:10 -0800 (PST)
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-434a83c6b01so23254265e9.0
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 23:24:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU5sbDpSjpeYGh5X+KgRTSJyTXyQk7yMhVwRjjv1Qq4rBc9lHq/gOOQjNNcWMRO/l5PTC7dWPwpOw==@vger.kernel.org
X-Received: by 2002:a17:907:7758:b0:aa5:3d75:f419 with SMTP id
 a640c23a62f3a-aa580f2af8bmr1208100366b.13.1732950961012; Fri, 29 Nov 2024
 23:16:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241130044909.work.541-kees@kernel.org>
In-Reply-To: <20241130044909.work.541-kees@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 29 Nov 2024 23:15:44 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjAmu9OBS--RwB+HQn4nhUku=7ECOnSRP8JG0oRU97-kA@mail.gmail.com>
Message-ID: <CAHk-=wjAmu9OBS--RwB+HQn4nhUku=7ECOnSRP8JG0oRU97-kA@mail.gmail.com>
Subject: Re: [PATCH] exec: Make sure task->comm is always NUL-terminated
To: Kees Cook <kees@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chen Yu <yu.c.chen@intel.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000007218e906281c16e8"

--0000000000007218e906281c16e8
Content-Type: text/plain; charset="UTF-8"

Edited down to just the end result:

On Fri, 29 Nov 2024 at 20:49, Kees Cook <kees@kernel.org> wrote:
>
>  void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
>  {
>         size_t len = min(strlen(buf), sizeof(tsk->comm) - 1);
>
>         trace_task_rename(tsk, buf);
>         memcpy(tsk->comm, buf, len);
>         memset(&tsk->comm[len], 0, sizeof(tsk->comm) - len);
>         perf_event_comm(tsk, exec);
>  }

I actually don't think that's super-safe either. Yeah, it works in
practice, and the last byte is certainly always going to be 0, but it
might not be reliably padded.

Why? It walks over the source twice. First at strlen() time, then at
memcpy. So if the source isn't stable, the end result might have odd
results with NUL characters in the middle.

And strscpy() really was *supposed* to be safe even in this case, and
I thought it was until I looked closer.

But I think strscpy() can be saved.

Something (UNTESTED!) like the attached I think does the right thing.
I added a couple of "READ_ONCE()" things to make it really super-clear
that strscpy() reads the source exactly once, and to not allow any
compiler re-materialization of the reads (although I think that when I
asked people, it turns out neither gcc nor clang rematerialize memory
accesses, so that READ_ONCE is likely more a documentation ad
theoretical thing than a real thing).

And yes, we could make the word-at-a-time case also know about masking
the last word, but it's kind of annoying and depends on byte ordering.

Hmm? I don't think your version is wrong, but I also think we'd be
better off making our 'strscpy()' infrastructure explicitly safe wrt
unstable source strings.

          Linus

--0000000000007218e906281c16e8
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_m43u8l1f0>
X-Attachment-Id: f_m43u8l1f0

IGxpYi9zdHJpbmcuYyB8IDE0ICsrKysrKystLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNyBpbnNl
cnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2xpYi9zdHJpbmcuYyBiL2xp
Yi9zdHJpbmcuYwppbmRleCA3NjMyN2I1MWUzNmYuLmEyYTY3OGU0NTM4OSAxMDA2NDQKLS0tIGEv
bGliL3N0cmluZy5jCisrKyBiL2xpYi9zdHJpbmcuYwpAQCAtMTM3LDcgKzEzNyw3IEBAIHNzaXpl
X3Qgc2l6ZWRfc3Ryc2NweShjaGFyICpkZXN0LCBjb25zdCBjaGFyICpzcmMsIHNpemVfdCBjb3Vu
dCkKIAlpZiAoSVNfRU5BQkxFRChDT05GSUdfS01TQU4pKQogCQltYXggPSAwOwogCi0Jd2hpbGUg
KG1heCA+PSBzaXplb2YodW5zaWduZWQgbG9uZykpIHsKKwl3aGlsZSAobWF4ID4gc2l6ZW9mKHVu
c2lnbmVkIGxvbmcpKSB7CiAJCXVuc2lnbmVkIGxvbmcgYywgZGF0YTsKIAogCQljID0gcmVhZF93
b3JkX2F0X2FfdGltZShzcmMrcmVzKTsKQEAgLTE1MywxMCArMTUzLDEwIEBAIHNzaXplX3Qgc2l6
ZWRfc3Ryc2NweShjaGFyICpkZXN0LCBjb25zdCBjaGFyICpzcmMsIHNpemVfdCBjb3VudCkKIAkJ
bWF4IC09IHNpemVvZih1bnNpZ25lZCBsb25nKTsKIAl9CiAKLQl3aGlsZSAoY291bnQpIHsKKwl3
aGlsZSAoY291bnQgPiAwKSB7CiAJCWNoYXIgYzsKIAotCQljID0gc3JjW3Jlc107CisJCWMgPSBS
RUFEX09OQ0Uoc3JjW3Jlc10pOwogCQlkZXN0W3Jlc10gPSBjOwogCQlpZiAoIWMpCiAJCQlyZXR1
cm4gcmVzOwpAQCAtMTY0LDExICsxNjQsMTEgQEAgc3NpemVfdCBzaXplZF9zdHJzY3B5KGNoYXIg
KmRlc3QsIGNvbnN0IGNoYXIgKnNyYywgc2l6ZV90IGNvdW50KQogCQljb3VudC0tOwogCX0KIAot
CS8qIEhpdCBidWZmZXIgbGVuZ3RoIHdpdGhvdXQgZmluZGluZyBhIE5VTDsgZm9yY2UgTlVMLXRl
cm1pbmF0aW9uLiAqLwotCWlmIChyZXMpCi0JCWRlc3RbcmVzLTFdID0gJ1wwJzsKKwkvKiBGaW5h
bCBieXRlIC0gZm9yY2UgTlVMIHRlcm1pbmF0aW9uICovCisJZGVzdFtyZXNdID0gMDsKIAotCXJl
dHVybiAtRTJCSUc7CisJLyogUmV0dXJuIC1FMkJJRyBpZiB0aGUgc291cmNlIGNvbnRpbnVlZC4u
ICovCisJcmV0dXJuIFJFQURfT05DRShzcmNbcmVzXSkgPyAtRTJCSUcgOiByZXM7CiB9CiBFWFBP
UlRfU1lNQk9MKHNpemVkX3N0cnNjcHkpOwogCg==
--0000000000007218e906281c16e8--

