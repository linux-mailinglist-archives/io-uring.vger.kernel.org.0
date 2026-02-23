Return-Path: <io-uring+bounces-12389-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eKDJGI2qnGklJwQAu9opvQ
	(envelope-from <io-uring+bounces-12389-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 20:29:17 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BB28C17C60E
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 20:29:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A6E993105581
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 19:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 023CC36A011;
	Mon, 23 Feb 2026 19:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Jq1QgJ27"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAE5369979
	for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 19:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771874121; cv=none; b=Rhgk9GqmfYroBkOB1id2U74fvG8Bf96N9HNko/In81H8ju6WGzGskqRub5E2An14CvBeRjLLXIxTFOL6MHFAbQljf3e4hM9y0rHA7TupSV8hncw/UynFT8IA682xdXnT6q7d8PeSU0og5pXGCqaSGrMaLYMv8PWdmtvDvGoi1jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771874121; c=relaxed/simple;
	bh=KHMRzLrzx0bFuoieu34Lu7CAeOR3r3aI+ogPHZCFAs0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=t/AGw+cpiNIT30ABSbFgss+QOGdmSqzCQRYtG8gb4f8Y6YhufRNtASIjyeDUMl6HxQ5wnsCRb4MmVOxNQ0XyEMnLBwEuisutAT3821Ual3ZjO8env2/PV93Ctq+5YZMD6EMXh1fk56cEEa0T3bqcOZGr6aablblg84A0HlkZULQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Jq1QgJ27; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d4b9c839b1so1851238a34.1
        for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 11:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771874119; x=1772478919; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ODHsUdsD13+eUwuSoGESpsAEqwz3zb6k+pxL615Ry+8=;
        b=Jq1QgJ27fHjhKk+LCmDF6vQwCSQ3ohzl+VXiUnkVaJfULUN0uQgCAtu2wl4rP8zS4T
         CtG2w+5qLgcwyvxTeswNb5lPJ5I5VWs4ad22VJnoyokDPCmODVUyvQREWOD/FsvbuTvO
         0nf5pHWZhc26acVzH2gqE2thBZYAHM9pOvKsmVrMCmb4DptX5oTuouM+Vu11qTvgX7uK
         m9xhphlAV7c8NueXDDVdQ8T1t6rFyxXAh5P8R8lJJlQEcNxLmpsX7UJYifJLoLeh/vsv
         uXqcaqPypkVDT4nSgQRJmOhP6gIvfTZDmBomNvc7pnC3XhuuPGqYezoAMT8jFktEoW5z
         +gHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771874119; x=1772478919;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ODHsUdsD13+eUwuSoGESpsAEqwz3zb6k+pxL615Ry+8=;
        b=L+CZfXwLESMGeIVVB/fIMMkKNIJ86lOXNAUugISIXkxdCV+1vBBwAu7sE5s4b22AI6
         K/Rjz41bqFhurYTp9h+G8rGc8vsDeUUexqwqL1951iX4mq6H4cD44eIuj1okT3x/NbsK
         1H4qZQNtGflC3QIWJpe8nKv/9e55D/eRtFvplx/3ieaS1bM1//32IivaBsHXoiQ1dnnN
         pfD7qETqKU1DE/5JENnYETvZXozNmk2tz+Vfct4X2uoOyOJfgZiJr+3o7QeJllzLlweF
         bAEMxEGekZHfvgOgnhF/NuDLht7lRysE3oubHj3QFCiNs/koR6cWUe9WJssROdsnEaoR
         PrqA==
X-Forwarded-Encrypted: i=1; AJvYcCV4CFfSJsjlXkzsKLoBxSVSiFmJAqfppGOG7K4x2jqemXetCVTGqk+ivNPc+rCjXBzbjP4r5HA/Ww==@vger.kernel.org
X-Gm-Message-State: AOJu0YzdwHM+0drrylQIKu7efx+L66ZoZggV5Dk6JWMtKnNFXFNyiQbw
	W8xQC6ICvQXDD8A9Q/wIPPWbJdflCDgwyD0BmFTECyLzEr/mJFqU0JTm13Md9qeS2vtcNlxMWkk
	zU60tqKM4CQ==
X-Gm-Gg: AZuq6aI5lsjP4cWBr1C8MCav8fP+u7+79TL2v8p5ONl34YEJi6XsxyzmXNzCz0cs6RM
	HsHbfSDYom9xIR6ts+TuC/ddvuYJhXqfR9l4qEN5Tr0xY/hKuYJJymuNZFGf5oAAi47mdQhZb4U
	zsFSQlPeL3s6YXzKblmu7E9iFAwjxFhI9mHd64CMoT4ULuutLfL5+EPl6W58ceheeUqLVb8iXUw
	KI9OIcrtfReQ1zcp2AnXY2o2SwWpX1ZrJUKuTS4sYCf9lYdABej/CpDOkFNzNeCE7aBXlTmETyx
	5XIl4IxCuBZ6SjBvC7O0iGzx+65Eg5njhSbOZsheTZDyU9E88Od2SPt2FtwlnYVvZDYy+LSpCod
	qFH9hOeMkZUvf8ka3zuvGYMtgUT0kxzQYyM9kHAvezQnZrqJ/6My9+gpjPEhruOeo2qBwIq603s
	4B2fATKObd3vU7QZvq9wIFXC2TD4Vf/772O6TE0Dwp1qOsMv9FlBW80wKEJ7BNonP70vSlilSw7
	83nqqsE
X-Received: by 2002:a05:6830:67ea:b0:7ce:2b34:deca with SMTP id 46e09a7af769-7d52c2cadc7mr8225612a34.28.1771874118880;
        Mon, 23 Feb 2026 11:15:18 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d52cf78503sm7944055a34.3.2026.02.23.11.15.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Feb 2026 11:15:18 -0800 (PST)
Message-ID: <e5b8042c-09b6-4d9a-bab9-c9693fbffa52@kernel.dk>
Date: Mon, 23 Feb 2026 12:15:17 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING in __secure_computing
From: Jens Axboe <axboe@kernel.dk>
To: Kees Cook <kees@kernel.org>
Cc: syzbot <syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, luto@amacapital.net,
 syzkaller-bugs@googlegroups.com, wad@chromium.org
References: <69953966.a70a0220.2c38d7.0111.GAE@google.com>
 <c71fc714-25b2-4c56-b48a-6d9da1d40d60@kernel.dk>
 <202602191048.395EE1E@keescook>
 <7d955b00-8cbf-4b09-9733-2c0d65e84e6e@kernel.dk>
Content-Language: en-US
In-Reply-To: <7d955b00-8cbf-4b09-9733-2c0d65e84e6e@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12389-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,syzkaller.appspot.com:url];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
X-Rspamd-Queue-Id: BB28C17C60E
X-Rspamd-Action: no action

On 2/20/26 6:44 AM, Jens Axboe wrote:
> On 2/19/26 11:53 AM, Kees Cook wrote:
>> On Wed, Feb 18, 2026 at 09:27:07AM -0700, Jens Axboe wrote:
>>> On 2/17/26 9:00 PM, syzbot wrote:
>>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13256722580000
>>>> [...]
>>>> WARNING: kernel/seccomp.c:1407 at __secure_computing+0x2ae/0x2e0 kernel/seccomp.c:1407, CPU#1: syz.0.17/6077
>>
>> This is:
>>
>>         /* Surviving SECCOMP_RET_KILL_* must be proactively impossible. */
>>         case SECCOMP_MODE_DEAD:
>>                 WARN_ON_ONCE(1);
>>                 do_exit(SIGKILL);
>>                 return -1;
>>
>> It's nice to see we caught an impossible state! :) Now we just need to
>> figure out what the repro is doing.
>>
>>> Not io_uring, no seccomp label that I can find...
>>
>> Why do you say this? The reproducer sets up io_uring and then calls
>> seccomp:
> 
> Because I don't see any related interaction there at all. As per usual,
> the syz repro ends up doing some odd SQ tweaking, which results in a
> bunch of readv and NOPs being issued. The former against signalfd. I
> don't see anything odd on the io_uring side outside of that. Well
> there's the usual nonsensical fuzzing io_uring_enter flag setting, like
> SQ_* which don't make sense for the ring setup, but these are just
> ignored.
> 
> It is possible that because of the tons of readv being queued that some
> io-wq activity will be occuring, and that could slow down certain paths
> like the signal handling. But seem orthogonal to me, as you could most
> likely accomplish the same with userside threads too.
> 
> I could be wrong of course! Note that I'm gone until next week, so not
> going to spend any time looking at this before then. Please do dive in
> if you have time, though...
> 
>> int main(void)
>> {
>> ...
>>   //  io_uring_enter arguments: [
>>   //    fd: fd_io_uring (resource)
>>   //    to_submit: int32 = 0x847ba (4 bytes)
>>   //    min_complete: int32 = 0x0 (4 bytes)
>>   //    flags: io_uring_enter_flags = 0xe (8 bytes)
>>   //    sigmask: nil
>>   //    size: len = 0x0 (8 bytes)
>>   //  ]
>>   syscall(
>>       __NR_io_uring_enter, /*fd=*/r[1], /*to_submit=*/0x847ba,
>>       /*min_complete=*/0,
>>       /*flags=IORING_ENTER_EXT_ARG|IORING_ENTER_SQ_WAIT|IORING_ENTER_SQ_WAKEUP*/
>>       0xeul, /*sigmask=*/0ul, /*size=*/0ul);
>>   //  seccomp$SECCOMP_SET_MODE_FILTER_LISTENER arguments: [
>>   //    op: const = 0x1 (8 bytes)
>>   //    flags: seccomp_flags_listener = 0x0 (8 bytes)
>>   //    arg: ptr[in, sock_fprog] {
>>   //      sock_fprog {
>>   //        len: len = 0x1 (2 bytes)
>>   //        pad = 0x0 (6 bytes)
>>   //        filter: ptr[in, array[sock_filter]] {
>>   //          array[sock_filter] {
>>   //            sock_filter {
>>   //              code: int16 = 0x6 (2 bytes)
>>   //              jt: int8 = 0xff (1 bytes)
>>   //              jf: int8 = 0x1 (1 bytes)
>>   //              k: int32 = 0x3fff0000 (4 bytes)
>>   //            }
>>   //          }
>>   //        }
>>   //      }
>>   //    }
>>   //  ]
>>   //  returns fd_seccomp
>>   NONFAILING(*(uint16_t*)0x200000000240 = 1);
>>   NONFAILING(*(uint64_t*)0x200000000248 = 0x2000000003c0);
>>   NONFAILING(*(uint16_t*)0x2000000003c0 = 6);
>>   NONFAILING(*(uint8_t*)0x2000000003c2 = -1);
>>   NONFAILING(*(uint8_t*)0x2000000003c3 = 1);
>>   NONFAILING(*(uint32_t*)0x2000000003c4 = 0x3fff0000);
>>   syscall(__NR_seccomp, /*op=*/1ul, /*flags=*/0ul, /*arg=*/0x200000000240ul);
>>   return 0;
>> }
>>
>> So something has gone weird here, I assume related to seccomp listener
>> vs io_uring and process death.
> 
> See above on potentially lots of threads being kicked off. But probably
> reproducing this first would be a good step towards fixing it.

No threads are being kicked off - from strace, this seems to be the key:

seccomp(SECCOMP_SET_MODE_FILTER, 0, {len=1, filter=0x2000000003c0}) = 0
exit_group(0)                           = 231
--- SIGSEGV {si_signo=SIGSEGV, si_code=SI_KERNEL, si_addr=NULL} ---
exit_group(11)    

as that WARN_ON_ONCE() in the report is indeed triggered off the
2nd exit_group() syscall.

-- 
Jens Axboe


