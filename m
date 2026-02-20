Return-Path: <io-uring+bounces-12345-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WHk3EH5ImGnYFAMAu9opvQ
	(envelope-from <io-uring+bounces-12345-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 12:41:50 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B03D016754C
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 12:41:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7B6B0300DD54
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 11:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 479A9340279;
	Fri, 20 Feb 2026 11:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aX8XHiJD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EB433E379
	for <io-uring@vger.kernel.org>; Fri, 20 Feb 2026 11:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771587705; cv=none; b=MsPQqHXsTF5TxsigyBrCqpFQ6aIPhD6WZIiqMI5bN1m2rlg5V8Fd+vJBLCgD0MTTsXXIR5R0tV+HnVGVI4+lO9e1mLLkWA8yds73dqcYPZvO7bwKJwRgAxP9InhwD0u/6v1GlWRemFMU+43zoqJ22Z8meAkix9S5J7muA51Ki74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771587705; c=relaxed/simple;
	bh=4WcHVq/mBoFtbakeXA8Ckz4sLPUFLeGRkbrobjpbn0w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D7p28rfS4O5vqVMLun0O62De6PAwuftyEEkJfu0FYC7yU0wtltDXl/C8sTOIQ8iNRbN+6NYef+IIOF4eWiu+v5QJjyBOHp/uNkVskUvCjrrhOwD4f4qiKCulOsvYsa/3I1N9O7RRVhyWzFd3LKXqBLmKpK8vXQWZS3yvU53yqXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aX8XHiJD; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4362507f396so2000480f8f.0
        for <io-uring@vger.kernel.org>; Fri, 20 Feb 2026 03:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771587702; x=1772192502; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AOk6ajBtnq5VNeI1NZWqWE25yrvyUwGs5aAzkkENVww=;
        b=aX8XHiJDhukyKyo51NEqIHn1qyz5FKRNrffL/Nfc3P/SYkOOQQJ4r8OfxXDDGeL6g2
         KDfJ5B0SeWz6LEnUr1yciU9W/7Tb3E9iCxGKA9E6AhYOISSbRsfY6ESqvoJOLrD8j13l
         C9ksE6wvFRHfcO5yM4PIt9bSFgwsltxWHtguMmnruP12wUeA5MfylqCZ3SQsvQu5pgcM
         9O36pAMrxs72TU94OZrABOSFZMhITNAn4Ey8Ve0BwRXbngu9DaYLIij2gRk8Mt26MFOd
         ZfyRS8x8nJFtuie3w5c8aKkvu1Uaj0i3PBLPwOvJeVENluIEkYPADwo88xydBwOFm4MT
         bUwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771587702; x=1772192502;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AOk6ajBtnq5VNeI1NZWqWE25yrvyUwGs5aAzkkENVww=;
        b=nfXI8U52FzwSw51nSjDw+EsESPqGcaQTc0/HJyPhUsBLUfKTSg1xyfNKAJP5/F7eu2
         R9bttjEAjSghqXTCj8Kz1N5ZYreehJClH4+uXs88Q3MdU98I4OfA7O9J4LLXLpq9w3zc
         qp13UvdNbZGFRsVLFNvWZO0Qi19mX89mhJoQtTi9k7aQnI6J4uoteTOlFJgGnXPZs4yi
         GDAtgIN5Xr6Q/hdZkKxYhdI5whloFFW/UlXWni4EWEd5gavmSHRNqE0fpVMoY1Hl84EE
         Vyu4AA0vX85Z4VF4GTTIPLe15rlf14AQT9/Ubz6Ds7huPuFbCYGhJ19f0zpoX+xkuzej
         CL8w==
X-Gm-Message-State: AOJu0YxuUbyxfHemKeKUWURvnrx0DpTX/ydwa3stdhQ/3APXo9/pyEzD
	TnvwExjrfehgPA3pKpASxvNZ+m4YIbmrOBFFbg8eJBTQcgizhb7g+L9QiQiM9w==
X-Gm-Gg: AZuq6aIX2zcytlZKTVQwh+LLlAGMCgep3R6zm2EEZoK/4L4BieFe0a48AYSnrh2ElPH
	QRg3icxa2R8P9SMmBhmPNCVH3sDfHwctSNo/xgBO0pYUO/oEL5d2kNa2EqXp0EOE6hT82CxCi4D
	biijKJnQ6iz4mwovyMSz9MgRR6jCpN78F9SO6xJXGOkcHr2i7gLm/w6TKI9DjUsjRf6MmXK8Mg/
	c7buzphFUcXTrvLadEbZ1Xmk9iKyLQ4bojshde2mSewKo3GbJ0gSGJ9bXQITQIUIYJNEKKOMKbO
	gmYQv3lfHyY+WhR2DANzUrjKPPSrjwFbVBjeNAQAAZpRwAlxpOpdBEO5t4QnJmHsOVGyqG4ElAF
	sgtQNTDaeOiib2JvdCArMLebBtC7JZ6HTzdjQQnkpkErR3A05UgNYLxEC1si9tJ/pAzQ8ApxfGW
	xEho6t21NMlW9307ZfuJqC7e5ARFQPrr56ONl+FqCys8+PWNFolxPvkOPuMeaOtmo5ijd5J50YU
	KAshBO0uPElEaggBQX+ZdP+gO8hJY2ZaM1pfQcIPjyyfu2nNOT08mJyPZU=
X-Received: by 2002:a05:6000:24ca:b0:435:a0f6:115d with SMTP id ffacd0b85a97d-43958df1120mr15486609f8f.4.1771587701780;
        Fri, 20 Feb 2026 03:41:41 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796ad009bsm53909507f8f.39.2026.02.20.03.41.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Feb 2026 03:41:41 -0800 (PST)
Message-ID: <84e2f3ad-28f0-4e9a-804f-2647cba9b30f@gmail.com>
Date: Fri, 20 Feb 2026 11:41:39 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 5/5] selftests/io_uring: add a bpf io_uring selftest
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: io-uring <io-uring@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
 Jens Axboe <axboe@kernel.dk>
References: <cover.1771327059.git.asml.silence@gmail.com>
 <7cc147a959ac068c55dae4f540e38e9e4ab121e0.1771327059.git.asml.silence@gmail.com>
 <CAADnVQK0RaOA9ZYZdYyQxOzLde9MR8HpMM0SexcW59A9u7X2Jw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAADnVQK0RaOA9ZYZdYyQxOzLde9MR8HpMM0SexcW59A9u7X2Jw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12345-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B03D016754C
X-Rspamd-Action: no action

On 2/19/26 19:01, Alexei Starovoitov wrote:
> On Tue, Feb 17, 2026 at 3:33 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> +
>> +static inline void write_stats(int idx, unsigned int v)
>> +{
>> +       u32 key = idx;
>> +       u64 *val;
>> +
>> +       val = bpf_map_lookup_elem(&res_map, &key);
>> +       if (val)
>> +               *val += v;
>> +}
> 
> Since these examples will be copied around, let's use
> good coding practices. Use properly named global variables
> for stats and counters, and drop this opaque array.

ok

...
>> +       unsigned to_wait = cq_hdr->tail - cq_hdr->head;
>> +       to_wait = t_min(to_wait, CQ_ENTRIES);
>> +       for (int i = 0; i < to_wait; i++) {
>> +               struct io_uring_cqe *cqe = &cqes[cq_hdr->head & (CQ_ENTRIES - 1)];
>> +
>> +               if (cqe->user_data != REQ_TOKEN) {
>> +                       write_result(-3);
>> +                       return IOU_LOOP_STOP;
>> +               }
>> +               cq_hdr->head++;
>> +       }
> 
> CQ_ENTRIES is just 8.
> Is it enough for real progs?
> Does the above approach scale ?

Depends on the workload. If you're keeping queue depth 8 with a
storage workload, it's all you need, and those don't go too high.
For net recv workloads, it's batched well if you get 8-16 CQEs per
wait, but unfortunately too often it's close to 1. You'd still bump
the CQ size in cases there are bursts in traffic.

We can come up with cases when it's higher, but what's important is
that you don't need to process all CQEs in a single BPF call. I bound
the loop at CQ_ENTRIES for convenience, but the user can set the CQ
size to whatever is needed, process some capped number every time,
and finish the rest if any next time it's called. E.g.

CQ_ENTRIES = 2^14
const max_cqes_batch = 32;

cqes_to_process = cq_hdr->tail - cq_hdr->head;
cqes_to_process = min(cqes_to_process, max_cqes_batch);
process_cqes_nr(cqes_to_process, ...);

if (cqes_left)
	to_wait = 0;

I'll make the CQ size a load time constant and clean up the
program, should make it a better example.

> I mean the above works as a bounded loop because loop
> count is small, but for 100+ you want open coded iterators.

Sure, but let's do that as a follow up when it's needed?

> In general all progs seem to be toy progs.
> Would be good to have something more realistic.

The other two programs are not toys but rather tests. Nop requests in
this one do nothing useful, but that'll be a good queue processing
starting template. Replace nops with reads and it's doing actual IO.
Add writes requests with some offset logic and it copies data b/w files.
I had such examples, but selftests is not the best place for that.
It can use abstractions, and I want to make them reusable instead
of people copy-pasting from selftests.

-- 
Pavel Begunkov


