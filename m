Return-Path: <io-uring+bounces-12348-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MKJ+CRpmmGmJHgMAu9opvQ
	(envelope-from <io-uring+bounces-12348-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 14:48:10 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AB9216805F
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 14:48:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 026FB300914A
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 13:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85A2C34846A;
	Fri, 20 Feb 2026 13:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IxXpJ3JZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f195.google.com (mail-oi1-f195.google.com [209.85.167.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D8E34887B
	for <io-uring@vger.kernel.org>; Fri, 20 Feb 2026 13:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771595098; cv=none; b=NUi0L5k4BT4NpTn3obyx0SYzIaZqCN4jrpbrL2YVU+DJeV1Q3gtjO26RXxxF4S16DCmhtGVphTC4mqmTIjE75vDkYXhCXV/trQz6Ejy+jwQQRUKLA/2liv+PSc/ry1L5i+HXb2vTUlBQ/x6rBsh9Vrp4RSZilbPlxmSfhcW2hGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771595098; c=relaxed/simple;
	bh=kI5Clb0yGAyWnRWKZjSsWTSpgcQmJC5g3S7r/17wMAY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e0pWH9zAYxxkw/NAYxC7cJPLLUMnWxYpIeLcWC9dXBz6pHAlBZOUUUfqJdFtPG/5VdXcUc/Zmv9y8RcdcJFV2UHsMQHuoMvYUNycFaJTRo5o93yn3c5SE+ErscCBaWM2aYdVAmzhpzVn80U5ieToxg9mrkpj9CXdGLOfkc/Z7aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IxXpJ3JZ; arc=none smtp.client-ip=209.85.167.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f195.google.com with SMTP id 5614622812f47-463a0e14abfso1341578b6e.2
        for <io-uring@vger.kernel.org>; Fri, 20 Feb 2026 05:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771595095; x=1772199895; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YEPBAqSJxDhbFA+s3a3XAj9+X2vk2K8DNtZkBh8tQHY=;
        b=IxXpJ3JZfHcd8SKXnFFkGI20M7jw+Xkk1g4RgXjccqD0eWdlIFGeKRKpN0ulW/5ylr
         IxD1Ee1AOJNx+YLyLxpkaKiBC+NZz5PPj9iOPjeZPKAyAUk98/mM2ekY4gUpIntnqZLw
         11NPCSF1DZip/dey0PJ6lHsLwWvmep7enti4IGWump9j1wa1mHEsk1vK1o0uk3dLYWaJ
         Cp2fJ3zrYacc4MHrmC7l6eXdpoZV/SQq6AdblYn8zx3m9qvTwoD4gmFGDjQbYwvr5Fc0
         SN67bZPoVhwTU6onpaDCDr92H39BJVvxiXmXkCplzhCdK3kAFIbJMKwhiU84vJ7CAFAi
         d65w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771595095; x=1772199895;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YEPBAqSJxDhbFA+s3a3XAj9+X2vk2K8DNtZkBh8tQHY=;
        b=EuS7ppPu3u2h4+FWVdyqmhKx6gExGNZwJ1hyTZlaQ4/tP70KzDfB+MjnaNSRLcLlFh
         jDBphIXFaOAOtWPUpg/n+fStiKLPleaAznse00k6kin++7lMoc4ppbEISStQkpLZxCe2
         ZTpATp2DZkpSg/1UlSJ2ownsb7G/XfcVHDnbF3BX7E8LPQ2ACpoyB/qzEEZJ8fxtCz3N
         X6QRw7X7m/hqxwuBmpWnExKDgnxQPCXgtz6yRBrQ6Es3soPczyl4HkqAsTy7R7pQJCqb
         FaUhUuUuokMzaGm2a/wkSaN05BaZXGpPTZ36xIxhi6aMNv8XTNgldZCpSJ+J+FEIc609
         uIwA==
X-Forwarded-Encrypted: i=1; AJvYcCV43OrL7oPziisYYzcW7AxGIEErB86vtFC15LbmaKHzSA8Es4HpoUD6UocjaY3kBAe75QIFhL5j1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YymEgxHbcUsEnvqSEczu5SofXVy/9zjjv+Mx2Zt8jKmKCmkPHJG
	8smQZ0opINRVpTCyNbXUjfQqjGMJ+UTL9EOj5fyM0178NVICW+PTJxPXqVwbFxYcnwA=
X-Gm-Gg: AZuq6aJAXd2tSo51zJ9ivi2UlR66F3622BO0oephpK+TlVeuRiOMDNLOTGrXMYKWaJ/
	QmFytSgYjVoe1U/t5/zCgPaVJJYaiLxhGTBZ06/7giWIyBVSZ6awnFbVt15c1E0W/tY1KkMnGSs
	Xc4S0bR5h+qPMmw/wpZ8LuHKjHBY0Sl9dn0c4FKh25+0R3j5LSBtBFOo4g6LG0xpbyaBiJZnLz0
	/1i9x1+iXB3L6tIH9OgSSqfK5AY4X0YPLu+WieT+/JXN7cMQ0ta8/EztX/BO6c9PT0sy9XrDCs+
	Cw9L4ujJ1LHatGuJkyfo3ZVho/N+as9YpyQuqxc/qaaGEWa3PhQ/0C4121qYEr3MFAUh6SUtAS/
	FBirkcqyC+Xs1orRXVpmIq+qTWuVG+KAaeqk2U4+qn9Adf7mEXgjT/LeFWlp1KhOqIYIHzhc6Wk
	+QrV+oweEoFuftaOrxjndwJyhK6CjYgJewiOzwSvYRUvS4xyDF9vU0rqtE8Rqtcw11ljXiZwLlI
	UlJhGH0dkBbcg==
X-Received: by 2002:a05:6808:f11:b0:45f:2788:b006 with SMTP id 5614622812f47-4643ba958fbmr1020325b6e.0.1771595094998;
        Fri, 20 Feb 2026 05:44:54 -0800 (PST)
Received: from [172.25.209.35] ([187.223.170.195])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40ee06756easm24302859fac.13.2026.02.20.05.44.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Feb 2026 05:44:54 -0800 (PST)
Message-ID: <7d955b00-8cbf-4b09-9733-2c0d65e84e6e@kernel.dk>
Date: Fri, 20 Feb 2026 06:44:53 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING in __secure_computing
To: Kees Cook <kees@kernel.org>
Cc: syzbot <syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, luto@amacapital.net,
 syzkaller-bugs@googlegroups.com, wad@chromium.org
References: <69953966.a70a0220.2c38d7.0111.GAE@google.com>
 <c71fc714-25b2-4c56-b48a-6d9da1d40d60@kernel.dk>
 <202602191048.395EE1E@keescook>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <202602191048.395EE1E@keescook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12348-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,0a4c46806941297fecb9];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Queue-Id: 6AB9216805F
X-Rspamd-Action: no action

On 2/19/26 11:53 AM, Kees Cook wrote:
> On Wed, Feb 18, 2026 at 09:27:07AM -0700, Jens Axboe wrote:
>> On 2/17/26 9:00 PM, syzbot wrote:
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13256722580000
>>> [...]
>>> WARNING: kernel/seccomp.c:1407 at __secure_computing+0x2ae/0x2e0 kernel/seccomp.c:1407, CPU#1: syz.0.17/6077
> 
> This is:
> 
>         /* Surviving SECCOMP_RET_KILL_* must be proactively impossible. */
>         case SECCOMP_MODE_DEAD:
>                 WARN_ON_ONCE(1);
>                 do_exit(SIGKILL);
>                 return -1;
> 
> It's nice to see we caught an impossible state! :) Now we just need to
> figure out what the repro is doing.
> 
>> Not io_uring, no seccomp label that I can find...
> 
> Why do you say this? The reproducer sets up io_uring and then calls
> seccomp:

Because I don't see any related interaction there at all. As per usual,
the syz repro ends up doing some odd SQ tweaking, which results in a
bunch of readv and NOPs being issued. The former against signalfd. I
don't see anything odd on the io_uring side outside of that. Well
there's the usual nonsensical fuzzing io_uring_enter flag setting, like
SQ_* which don't make sense for the ring setup, but these are just
ignored.

It is possible that because of the tons of readv being queued that some
io-wq activity will be occuring, and that could slow down certain paths
like the signal handling. But seem orthogonal to me, as you could most
likely accomplish the same with userside threads too.

I could be wrong of course! Note that I'm gone until next week, so not
going to spend any time looking at this before then. Please do dive in
if you have time, though...

> int main(void)
> {
> ...
>   //  io_uring_enter arguments: [
>   //    fd: fd_io_uring (resource)
>   //    to_submit: int32 = 0x847ba (4 bytes)
>   //    min_complete: int32 = 0x0 (4 bytes)
>   //    flags: io_uring_enter_flags = 0xe (8 bytes)
>   //    sigmask: nil
>   //    size: len = 0x0 (8 bytes)
>   //  ]
>   syscall(
>       __NR_io_uring_enter, /*fd=*/r[1], /*to_submit=*/0x847ba,
>       /*min_complete=*/0,
>       /*flags=IORING_ENTER_EXT_ARG|IORING_ENTER_SQ_WAIT|IORING_ENTER_SQ_WAKEUP*/
>       0xeul, /*sigmask=*/0ul, /*size=*/0ul);
>   //  seccomp$SECCOMP_SET_MODE_FILTER_LISTENER arguments: [
>   //    op: const = 0x1 (8 bytes)
>   //    flags: seccomp_flags_listener = 0x0 (8 bytes)
>   //    arg: ptr[in, sock_fprog] {
>   //      sock_fprog {
>   //        len: len = 0x1 (2 bytes)
>   //        pad = 0x0 (6 bytes)
>   //        filter: ptr[in, array[sock_filter]] {
>   //          array[sock_filter] {
>   //            sock_filter {
>   //              code: int16 = 0x6 (2 bytes)
>   //              jt: int8 = 0xff (1 bytes)
>   //              jf: int8 = 0x1 (1 bytes)
>   //              k: int32 = 0x3fff0000 (4 bytes)
>   //            }
>   //          }
>   //        }
>   //      }
>   //    }
>   //  ]
>   //  returns fd_seccomp
>   NONFAILING(*(uint16_t*)0x200000000240 = 1);
>   NONFAILING(*(uint64_t*)0x200000000248 = 0x2000000003c0);
>   NONFAILING(*(uint16_t*)0x2000000003c0 = 6);
>   NONFAILING(*(uint8_t*)0x2000000003c2 = -1);
>   NONFAILING(*(uint8_t*)0x2000000003c3 = 1);
>   NONFAILING(*(uint32_t*)0x2000000003c4 = 0x3fff0000);
>   syscall(__NR_seccomp, /*op=*/1ul, /*flags=*/0ul, /*arg=*/0x200000000240ul);
>   return 0;
> }
> 
> So something has gone weird here, I assume related to seccomp listener
> vs io_uring and process death.

See above on potentially lots of threads being kicked off. But probably
reproducing this first would be a good step towards fixing it.

-- 
Jens Axboe

