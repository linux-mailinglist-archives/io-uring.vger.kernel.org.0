Return-Path: <io-uring+bounces-12415-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GFGsHMnvnmk/XwQAu9opvQ
	(envelope-from <io-uring+bounces-12415-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 13:49:13 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 97FAA19797B
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 13:49:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 95954300C6D0
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 12:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F2B13ACF0B;
	Wed, 25 Feb 2026 12:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kQfKwk+C"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AA73AEF59
	for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 12:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772023741; cv=none; b=p0SjbWjC8PKA/P8u38H4S+ypNdQqSEACmmSl2G/sty3PprmsY1HRHdRX0WyRxV3Z1LRv3K7/OBKj8NBj45plvX1yUEytziDOnboYDlBUpJelFH6Qcja9E6iXHcrjNkJRNHLx+bU542Wu7ljey0X41vuPlaS7AZN/VF3cRrMzz2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772023741; c=relaxed/simple;
	bh=TPtQecFLt3bKgAlUJv6uA3jD+8ENnPfJf8K8C1mKZj0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sfT9ZmVdkPUOuLWzGaacH4F70JQz63yQnz+CStdLl8PLFU2WvaygYW/3uhSQqrANl1EVa1DCcsR7NVdk6canfSxUfInH9OK5V8uFsilgp25vL+TZdBxe12sA4Y3Q9oNOfdolV2ErtbOa18Td51RHSrZOaNbBLRbJsfllGDoeEMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kQfKwk+C; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-389e71756d8so5450871fa.2
        for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 04:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772023738; x=1772628538; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tXh8nJgWerBQSiJBvjtEBHO2Vkt5cQS3cW38XI+++O8=;
        b=kQfKwk+CIjrrP8Zlj7mjGkTHHzn8CJKfxhsomIpcO7h7H0M+xBZm0RrD4AWEd9M92K
         C8dmrYe0uNdxLYhsSJtLTuVWI2Ou0lJtbxLIvO9zCoEBALiMl6EIo4Q6ThDkegrV6hq1
         k2dq0gehN3ugJsNwFKX0sWj2QtVHgoeTMMWoN8q4hgKAde8Dh8X5Kn2PYrZVjBoqAPTv
         LN1yha5LQ867eq4T3bfRixryA952jFJ4vZ0jtswfUA6Gy6TD50NSw34Zq9u3dWLr3Wr/
         uk4LiPXWNBAacXcKAhebFdTgBOwBewRUW/vkPQQEKSB9gV7HBqH2ABY+/KcK79Zo3PiZ
         SjuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772023738; x=1772628538;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tXh8nJgWerBQSiJBvjtEBHO2Vkt5cQS3cW38XI+++O8=;
        b=GMwOXo3DitxIkRebo51y0VVTxDU4zchVBx79n9we+sLK8AM1L7//Dj7qqfgDVm1Dcm
         mtHoaBI9OpCOOKtcRJ9RBrFY0Jqs0EoobdALi2Q6Kaoys4rxMl2JYF5RH4EE245aGz42
         gYSCgyq7xWj4jOS4Kh5J5fVFlZa5YfaEpq6SCogysk47+hc81ZWidOZd4N8ohfQpPFPj
         dKo1iSZuOHbz/D+9NwJAEJ/Pz98ZdTgrNmdJpv0jSFc42fCupsAl2+6IS4O4TFwG/8O/
         J1Xf3wW64fujE0PeibQA7cH+JcFg37kFD5LWGp6I3ok2ymbTl+yukhq2v+mKQShFPydZ
         kPJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJMJ1tbIx7RhEJVINrsssw5Qo7uvWEDBW+zbNRUwqN0Q+DEIE+J/FdVnN2Asu9SV79Z0zovvpdjA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxnhSQ1dxL3+w0X6/zC93sYu6duDjWKUyX2v7HENbIIjZpkFxCy
	QZmQQxtun63Ll/Zt2B8eEZ3Q17MEBQvsF9bmG71njjp+3NgUTIYaPSwUnUWRuw==
X-Gm-Gg: ATEYQzxaFBqaauY8Jyg2KfJ5o+fpVyusXFaP9Qbim2YWy/sYCw9TNNysM4wrQKSqRqt
	jPL4pdTxVwvG9UqxQ+0t/+NTcifmm5dB52mBY6Wk2nIgGekaLEofOrQOxNLzAEQtC90Y6XmNWEv
	ZYfscaoPm4o8lmv5dgUlPtyd7b7MHpgLjifJofsyu+sNjFLcuh7hXMaodk905NQtsYC9yV6mAiG
	bIfBGYdMcaH7VpOCjvRMk4TQtI1XIRiFjyaCisqc1AV1kJN/KG/2cM6Vz/vxADqeq2CD+8dicIE
	9gGotiFOYLXCx9f+DpExBWVTCnxlTrxIBgCzwcJII7B+IvjPBWyjJeu/6WfRS7cKh0wNm55ZCnf
	FFMjVFd6/lnbQIzkhI7JxSBbCrPY8JlXbbpOMGvwvFVMbTz1cJBiOqDOcQQd99aLqc2Re/But8Q
	Yp35/znc0O16hkyBm/s0PRyQosC1UDNf/3VTHrrSEzgiP6RqUvgkPmPAEneJqecMLEakydieN0t
	6Z82j2Os2MDji6/Upi9Tq0JGSrPDeuWeNS/Gs8gGz6vHpSfTSX/hBUbpw==
X-Received: by 2002:a17:906:f59a:b0:b8e:d04e:e4fc with SMTP id a640c23a62f3a-b9081a0cbefmr898192366b.22.1772017948488;
        Wed, 25 Feb 2026 03:12:28 -0800 (PST)
Received: from [10.112.148.141] (82-132-214-161.dab.02.net. [82.132.214.161])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9084ee4d63sm508858366b.62.2026.02.25.03.12.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 03:12:27 -0800 (PST)
Message-ID: <22073d2a-31ea-46c2-bb4a-b771b2fcf8ee@gmail.com>
Date: Wed, 25 Feb 2026 11:12:24 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 5/5] selftests/io_uring: add a bpf io_uring selftest
To: Ming Lei <ming.lei@redhat.com>
Cc: Ming Lei <tom.leiming@gmail.com>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 io-uring <io-uring@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Xiao Ni <xni@redhat.com>,
 Caleb Sander Mateos <csander@purestorage.com>
References: <cover.1771327059.git.asml.silence@gmail.com>
 <7cc147a959ac068c55dae4f540e38e9e4ab121e0.1771327059.git.asml.silence@gmail.com>
 <CAADnVQK0RaOA9ZYZdYyQxOzLde9MR8HpMM0SexcW59A9u7X2Jw@mail.gmail.com>
 <84e2f3ad-28f0-4e9a-804f-2647cba9b30f@gmail.com>
 <CAADnVQLSEoZ0V1m5j3ggX0o0gzVKyiDHL=J6F0wRXB8qk-MCGA@mail.gmail.com>
 <591a7f0e-7b78-42f1-9486-163249f5e306@gmail.com>
 <CACVXFVPx5AcC9y9xVPCaahDeumNGm4TSkkfhsJ8w+wmW52JQ4w@mail.gmail.com>
 <ed7b85d0-38d0-413c-a28a-f3b0d1a72a13@gmail.com>
 <CAFj5m9L_WPH_du4GMVYGBdYA_NX1kbGtJpAP0hbfuEjuk5faZw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAFj5m9L_WPH_du4GMVYGBdYA_NX1kbGtJpAP0hbfuEjuk5faZw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk,redhat.com,purestorage.com];
	TAGGED_FROM(0.00)[bounces-12415-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.994];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 97FAA19797B
X-Rspamd-Action: no action

On 2/25/26 08:41, Ming Lei wrote:
> On Tue, Feb 24, 2026 at 12:30 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 2/23/26 15:23, Ming Lei wrote:
>>> On Sat, Feb 21, 2026 at 6:35 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>
>>>> On 2/20/26 17:45, Alexei Starovoitov wrote:
>>>>> On Fri, Feb 20, 2026 at 3:41 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>>>
>>>>>> I had such examples, but selftests is not the best place for that.
>>>>>> It can use abstractions, and I want to make them reusable instead
>>>>>> of people copy-pasting from selftests.
>>>>>
>>>>> Sure, but please still post them as extra patches so it's easier
>>>>> to see what's the end result.
>>>>>
>>>>> Also please reply to that thread:
>>>>> https://lore.kernel.org/bpf/CALTww28QMg=YXqKWpWLZrLO+xiqOe3LGyput8dx68-dnQsxg=g@mail.gmail.com/
>>>>>
>>>>> It's not clear to me whether your io_uring+bpf setup will work
>>>>> for Xiao's use case.
>>>>> I don't think we need 2 ways of doing it.
>>>>
>>>> We discussed this with Ming on the list before, that's one of the use
>>>> cases I target as well, there is no reason why it shouldn't work. The
>>>> difference is that this approach gives a flexible framework for
>>>> extensibility and covers a good bunch of other needs, which is exactly
>>>> the reason I moved from a BPF opcode approach, while Ming's proposal is
>>>> more specific but argued to be a way easier to plug into ublk servers.
>>>> If you ask me, we need a solution that covers a broader spectrum of
>>>> use cases, but I guess it all can be argued in either way.
>>>
>>> One big drawback of  Pavel's approach is that it needs a totally
>>> different userspace
>>> implementation for using BPF, which is just hard to use in existing
>>> io_uring applications.
>>
>> Not really, it depends on how you write it. If you need to rewrite CQ
> 
> I meant SQE has to be allocated & built in bpf prog, then it is inevitable
> to move application logic into bpf prog.

But that's what I'm saying, you don't need building sqes in bpf
to augment it with BPF checksumming / etc. I can elaborate when I
get some time, but to give a short example:

# bpf-prog.c:

unsigned csum_jobs;
unsigned regbuf_idx_to_csum;

loop() {
	if (csum_jobs) {
		kfunc_regbuf_do_csum(regbuf_idx_to_csum);
		csum_jobs = 0;
		...
	}

	// proceed to the default submit / lopp implementation
	// you'd expect from normal io_uring_submit_and_wait()
}

# user-prog.c

ring = create_ring();
load_my_bpf();

sqe = get_and_prep_sqe();
// normal submit+wait
io_uring_submit_and_wait();

cqe = get_cqes();
if (cqe->type == ...) {
	skel->bss->csum_jobs++;
	skel->bss->regbuf_idx_to_csum = idx_from_cqe(cqe);
	// use bpf arenas, io_uring regions for the real tning
}

// queue more sqes if needed

// this will do csum'ing and followed by submit+wait
io_uring_submit_and_wait();

> If the logic is complicated, it is one big thing.

The implementation above would be simple enough. And on top,
someone could try to do BPF submissions to cover cases like
you had with group request ordering (forgot the actual name).

> raid5 is a great example with complicated fast io code path, I'd suggest someone
> or Xiao or Caleb, try it. Compare your approach to the bpf opcode and draw
> some useful conclusions.  Code should be more convincing.
> 
> For bpf opcode approach I believe Xiao has already built an example.

It might be entertaining, but I wanted to stress that it's not
a blocker for my work. It can handle the use case with registered
buffers, but I aim at a more wider range of applications, which
wouldn't be covered by the opcode approach. And that's the reason
why I moved away from opcodes, it wasn't flexible enough.

-- 
Pavel Begunkov


