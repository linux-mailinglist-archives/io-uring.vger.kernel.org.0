Return-Path: <io-uring+bounces-12705-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mJQIEZqBuGltfAEAu9opvQ
	(envelope-from <io-uring+bounces-12705-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 23:18:02 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 70C432A1603
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 23:18:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F00E730B7AA8
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 22:14:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8720F35C1AE;
	Mon, 16 Mar 2026 22:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UqCxBnGc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8272139D
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 22:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773699243; cv=none; b=heoxjONkzGxs57EEP32trF2Q/pcWAV3qMjTJUD6DRRoxkihh3S7dwKljZ21wpXvYqVlHEU/pVRXRt7ewURFwGxzOg8w1uKFprl6DgzQw2jyaAMl309xTGeVaASVd2Z/LkSJFpMaRyfha8z28ppWEKqN+LfFqwc1n3jpyAhEl8ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773699243; c=relaxed/simple;
	bh=yf7LnFAH/20ojMzGfvo3YFdGZZ+8Gj569dfrgxe2Ve4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HeGnonlG+jydVkYiWZSAm3DM3p4gQ7AjI3+kSeAlCPiPXhEpGaIVF5SjgrvwQTWHoMbxq6KWUkNadmKaXD2gMWro0ou0vJBbqWLd60sUYxR5RdApAJ1wIj/8Reu/tCnqmcsKRmmtWOXAyFrF/Dq5zntZqjJMprH5inok8uTCfDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UqCxBnGc; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-466ebbf7ff7so1682789b6e.1
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 15:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773699241; x=1774304041; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GPwvoJ+HhUgl8bXKAn5EwOyGikkP/OfmER1NlRgJVCc=;
        b=UqCxBnGcVj/kgX5D4NZC3jgBUDKglK/dBZ2D8JCiU5N6z+BCi5rLT+4iQTlrXMQDHU
         47zReOSuhbX0d0a9iY8QnIBnlZk6nyIMpXLVO1jCl1D0DNv6WPRqMKIur6TnC1BEx+uM
         eFd/wy2r9VcoXFv3XWP3UWv26DtViyngxyTy17qvuTa34YvIY56SVfzzz1oMrU2cbRkM
         c+TBE9jh9PzZVDsowco/z1hrbSrcncUQzKAseTAdWAt4+vyKO+TTYKB2SaFPDgu0yh0Q
         LGyatNtpuW5z2uyKTFEpaYdkS1GN9fPCIT9JUtv3+6prbKfz8YR21KpIL4DKt6xJLe06
         RRqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773699241; x=1774304041;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GPwvoJ+HhUgl8bXKAn5EwOyGikkP/OfmER1NlRgJVCc=;
        b=UVeK08w0/y6gn+r5KYdjd7JtnoP+sWV9AuI9eNrXNXZL4TizmZ2JtUg7eiIjxn19pD
         zMb5sS4Pi9TJLSH88sYRhCBsJZDuK/1opJOELNuEpHN3zNvPT15g+Iu4UDa6W5po76jx
         q0fPfrG+HrHU9JmYAgiIUKh8rBRBCMtt+prNawXjatAEnewzv+Z4gNOcDkpsZjeIBIcP
         lfkDHZcdwZF+s2aDtyuFwFn4mWen0n2D2tD+kPIFjAcliWTSym84N8yQ3Q9zVL1S+rkO
         DFdZY999LN/WVMtwTxFlgVvIGFgOIfDHyh0fb3Wqqb4RvYL62tbdpl+bubOs9yIsQc7e
         pp2w==
X-Gm-Message-State: AOJu0YwExlquWfSGQUk8SvXuoZrseyiOjf1zibnQRzAYO3P59dF6LDXO
	Z3Wimb6vv5MGDIzlC/4PkTStoVPyegMcH8rrt/o1HE9XX5yoqBqlNCW6lLK2LuZpww8=
X-Gm-Gg: ATEYQzxyVKE3YR2Tx5ORqzthgfSH/8FMXbj2Olo6nv14B/EG4y5pLTIPE5WrV02oQpZ
	2p4gDhLgKMmD3LL8Gq5ood5/8YSPa0NB39R+glOlFMqoakXCzD/2vdSXkEFEgDSdc4279rg81nw
	MbJ0+C5cA5scR047Nui5RyG1B8GPuifTkQ7zz5F2+6bAT4t6cZb5eNMNzBm2j1kmJxbjdR/SY6g
	bdeReCkxDgZymMwsKhrvDgv9f23RWoel/Udcdc+6kJuJbotisof03uwuyGtXkgbO2a+afiONZz4
	TvxrPn6T06YKAwmxwTHAscxjHIeG2YdcVu7zz+9yY1p/7duSCSeMsAdrpK48VPGrQI+euWWghiC
	QLNXZCGcsKBwT4GAmbslVieEbgkTFVouusz1q7vq0sUbsueIRyATZSTOjjUuU2Wg7R8SsXcNGVt
	bNTk3Z51Mu1DJ3TnKxQJtya17lmWBLicEtLrwczWTdsV01tyrIbYWgO85ndF0C4fg7TJQlpaaFg
	JEV607EgA==
X-Received: by 2002:a05:6808:6ecc:b0:467:2a6e:adad with SMTP id 5614622812f47-467570374dbmr7908027b6e.11.1773699240783;
        Mon, 16 Mar 2026 15:14:00 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-467342ef6fesm10347379b6e.14.2026.03.16.15.13.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 15:14:00 -0700 (PDT)
Message-ID: <c75e0728-4619-4435-b4a4-9c80331a5408@kernel.dk>
Date: Mon, 16 Mar 2026 16:13:59 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 0/4] BPF controlled io_uring
To: Caleb Sander Mateos <csander@purestorage.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, bpf@vger.kernel.org,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <cover.1772109579.git.asml.silence@gmail.com>
 <d8c8748a-4b13-4097-bdeb-495e6410a0df@gmail.com>
 <CADUfDZoBTwnCo-f_st9-jdgNhHLWUCjZQFpGdowGUA5BoJ836w@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZoBTwnCo-f_st9-jdgNhHLWUCjZQFpGdowGUA5BoJ836w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12705-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[purestorage.com,gmail.com];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: 70C432A1603
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/9/26 9:02 AM, Caleb Sander Mateos wrote:
> On Mon, Mar 9, 2026 at 6:24?AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 2/26/26 12:48, Pavel Begunkov wrote:
>>> Introduces a way to override the standard io_uring_enter syscall
>>> execution with an extendible event loop, which can be controlled
>>> by BPF via new io_uring struct_ops or from within the kernel.
>>>
>>> There are multiple use cases I want to cover with this:
>>>
>>> - Syscall avoidance. Instead of returning to the userspace for
>>>    CQE processing, a part of the logic can be moved into BPF to
>>>    avoid excessive number of syscalls.
>>>
>>> - Access to in-kernel io_uring resources. For example, there are
>>>    registered buffers that can't be directly accessed by the userspace,
>>>    however we can give BPF the ability to peek at them. It can be used
>>>    to take a look at in-buffer app level headers to decide what to do
>>>    with data next and issuing IO using it.
>>>
>>> - Smarter request ordering and linking. Request links are pretty
>>>    limited and inflexible as they can't pass information from one
>>>    request to another. With BPF we can peek at CQEs and memory and
>>>    compile a subsequent request.
>>>
>>> - Feature semi-deprecation. It can be used to simplify handling
>>>    of deprecated features by moving it into the callback out core
>>>    io_uring. For example, it should be trivial to simulate
>>>    IOSQE_IO_DRAIN. Another target could be request linking logic.
>>>
>>> - It can serve as a base for custom algorithms and fine tuning.
>>>    Often, it'd be impractical to introduce a generic feature because
>>>    it's either niche or requires a lot of configuration. For example,
>>>    there is support min-wait, however BPF can help to further fine tune
>>>    it by doing it in multiple steps with different number of CQEs /
>>>    timeouts. Another feature people were asking about is allowing
>>>    to over queue SQEs but make the kernel to maintain a given QD.
>>>
>>> - Smarter polling. Napi polling is performed only once per syscall
>>>    and then it switches to waiting. We can do smarter and intermix
>>>    polling with waiting using the hook.
>>
>> Any comments for the patch set?
> 
> I'm not opposed to this feature, but I agree with Ming that it seems
> largely orthogonal to his patchset allowing BPF programs to access
> io_uring registered buffers[1]. This patchset doesn't provide any
> kfuncs for interacting with registered buffers, so we would still need
> something like the kfuncs implemented by Ming's patchset to allow BPF
> programs to access registered buffers directly. Although either the
> ->loop_step() or ->prep()/->issue() interface could allow userspace to
> run a BPF program in the context of the io_uring, I wouldn't be keen
> on reimplementing the entire io_uring_enter() loop logic just to
> intercept a few requests to run BPF programs. The ->prep()/->issue()
> abstraction seems more straightforward to me, though I understand that
> it's not as general as the ability to modify the behavior of the
> entire io_uring_enter() syscall.

Caleb/Ming, any objections to merging this patchset? I think we all
agree it doesn't cover everything that we would want, so far we have two
different patchsets out there, but they also aren't mutually exclusive.
In the hopes of getting the ball rolling on the buffer side too, I'd
like to move forward and merge this and then we can rebase Ming's stuff
on top where it makes sense?

-- 
Jens Axboe

