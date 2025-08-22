Return-Path: <io-uring+bounces-9237-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EC9D6B30A8B
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 02:59:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBF271CC6370
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 00:58:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 071CA381BA;
	Fri, 22 Aug 2025 00:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QXos0dCn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB38347C7
	for <io-uring@vger.kernel.org>; Fri, 22 Aug 2025 00:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755824302; cv=none; b=Xk88tGyxPTcCazguj0dJOnScT9VaFhuFiWbPpD6OgEi6CzmQ5NkwgiNAO2tYKOoNTus7VG5gTMTibTpmtsjbVyKM2+blaoH3bd1Ud2LIIswymxjOoZyLvVj9gM6yS8tYfCJt8fe7TtvZlvppWDcMb+pNXNGC9THqb605i4R3rwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755824302; c=relaxed/simple;
	bh=QlcdCqLGGHKWXS1IxRdMeCcPZTLfZcwUflF0ngU9yzU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aF5qC3Hr4bD0IAjcfGFs293uEetyi8THEe133t0rl1IlraFlRlDEslkQYUalzwdbyhA42vPbWPacxjvoSSgm8vMxxzHoAneNcyvjE16BBHVeXcXumpW+p6+BFSlvF7DShGQYcxOIGT5E0cs5RFpHQAZU89kSS2dasf/xzUTEkSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QXos0dCn; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-77033293ed8so57970b3a.0
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 17:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755824295; x=1756429095; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gfotxZk7YW3Ko4QLb4E6TrIiZzDRLl3rOeaM5R0EhDo=;
        b=QXos0dCnEAuIPRGQhJSyskB/ii8E79lRqeC8v/fWIk3DhaIj2OeBwEoPlYbBBoNcUB
         RD0NkGnXTLaDl96LhkTQGIASniKCUJ0R9Cwgiz2xSrfM1Y2hLjDGzXji3s0U2kSRVIQj
         IdrTTHsCSu+l0Uq+C70S0uFHnbIWzGfz7mDX0yXrZrl34VFx5a5dSTJGoSdAFzuFK0oz
         THwDEY9ZPxAx4TrwtQSkAN75CxOa12bv5u79QUu2StINYRp40BenI3JtBM8HAVH8KB32
         SSlJXwpNzABANudFnqHKcp+Kg6IqqjGET1yCK8SqxQ4N28SSxGc8+9edJb1SuZwXHsI8
         N9lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755824295; x=1756429095;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gfotxZk7YW3Ko4QLb4E6TrIiZzDRLl3rOeaM5R0EhDo=;
        b=KVLWsbsI1u9j2kZ9Ox1OjEeS4iStAmNVWn7RMArMHvsEMhax+AK8r36nzBs3IMRLrp
         YcBz/7OndXXXtpOitveVyFGJjerF4hoLpklqrlgNEHZvUqTK3eS1mkJiJ9ojpwjY+kqs
         6Sja79zChAeM1BbZsL/5159bpApuO6XKkxirPkgmWxDoQJdhob1pXVmMH4Y7tUPpBhHu
         XTeCR+8uohXK1HGDPLfh3MqHnOjzfVfrz0XRbHUJIVVk0MIaDJM4wcAj3jRxeOT0NNcU
         R779XqdLp71O6LM3fjHbb0sBWTmtG8y3/kFQPDW4yd4ySyEPTDnpkLJ6tRiTxPWXm0GY
         Pyxg==
X-Forwarded-Encrypted: i=1; AJvYcCVF3yy+ps5HAzwJVJC1v5k6iMgRSGK8y+AahXy+A2zOLYLPIiBpJGKziL37SWnE7OaxM/NDHzRzfQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzSdzT+luX6DYT7D7KpGRxIrbx4xACgWydNVN8ZSKyOdcBRqDR5
	Eji1P2YIUtqlKlkz3I8h3w9RsAJt/zQLREAcK32mk88Fr//hvph534PgSFK9tDogNVg=
X-Gm-Gg: ASbGnctCeebYBrMGf3iDZfytdy39rUpEfapUopYCe6wkSVo//JmYpZiGuR+E6Rglfq6
	Df5ooMD34w0Fk+0/TOnBjcGpbpcePjm0LLbgDa21cynoONtfyHG6VwoV2dgP8dQ4t6Zf/hUx2UR
	7CcK91ktDC4kmtl//dIFAlqDR6iCNcqn4K8Lnp+2shNdKceM6w9Ae5Ycz5hN0V/jhOi+7tbJ1Fh
	AOKVZdQBUoXlQ7dT6txMTBdu6jvC/B2oHKNs7OtTTtJF9an1DoN4GT+8V8ttPaDwicFW0I2NcCo
	MauGGDPxfjj7vw0UtwvqXXNR+EdwC3XpNUwRXbWDZTWgWpv77nYL7FEwATJ04CcrMn90kHi8e27
	kSCwALyUVy2Q8ONwWywFrxanw6cRgVWU=
X-Google-Smtp-Source: AGHT+IFSSQsKD6Qc2fYj088IeYhu8boxpNLqVfl00jr77JxxhRGtpD508w+/bmUrrv9S8hARuhBhjg==
X-Received: by 2002:a05:6a00:3c95:b0:75f:8239:5c2b with SMTP id d2e1a72fcca58-7702fad496dmr1346839b3a.23.1755824294979;
        Thu, 21 Aug 2025 17:58:14 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e7d11c8bcsm9426505b3a.33.2025.08.21.17.58.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 17:58:14 -0700 (PDT)
Message-ID: <f3a48404-9051-4ccc-8ea7-0532b5c469cb@kernel.dk>
Date: Thu, 21 Aug 2025 18:58:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 2/2] io_uring: uring_cmd: add multishot support
To: Ming Lei <ming.lei@redhat.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>, io-uring@vger.kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>
References: <20250821040210.1152145-1-ming.lei@redhat.com>
 <20250821040210.1152145-3-ming.lei@redhat.com>
 <CADUfDZrUUZzhMw4z=Q0U7PAzp+0Aj_=NNyY6kJH21uQL36B-Fw@mail.gmail.com>
 <a9d16693-b52e-42c7-97aa-52484e4ce510@kernel.dk> <aKe_MZLcs5n1Uobw@fedora>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <aKe_MZLcs5n1Uobw@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/21/25 6:52 PM, Ming Lei wrote:
> On Thu, Aug 21, 2025 at 10:38:57AM -0600, Jens Axboe wrote:
>> On 8/21/25 10:29 AM, Caleb Sander Mateos wrote:
>>> On Wed, Aug 20, 2025 at 9:02?PM Ming Lei <ming.lei@redhat.com> wrote:
>>>>
>>>> Add UAPI flag IORING_URING_CMD_MULTISHOT for supporting multishot
>>>> uring_cmd operations with provided buffer.
>>>>
>>>> This enables drivers to post multiple completion events from a single
>>>> uring_cmd submission, which is useful for:
>>>>
>>>> - Notifying userspace of device events (e.g., interrupt handling)
>>>> - Supporting devices with multiple event sources (e.g., multi-queue devices)
>>>> - Avoiding the need for device poll() support when events originate
>>>>   from multiple sources device-wide
>>>>
>>>> The implementation adds two new APIs:
>>>> - io_uring_cmd_select_buffer(): selects a buffer from the provided
>>>>   buffer group for multishot uring_cmd
>>>> - io_uring_mshot_cmd_post_cqe(): posts a CQE after event data is
>>>>   pushed to the provided buffer
>>>>
>>>> Multishot uring_cmd must be used with buffer select (IOSQE_BUFFER_SELECT)
>>>> and is mutually exclusive with IORING_URING_CMD_FIXED for now.
>>>>
>>>> The ublk driver will be the first user of this functionality:
>>>>
>>>>         https://github.com/ming1/linux/commits/ublk-devel/
>>>>
>>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>>> ---
>>>>  include/linux/io_uring/cmd.h  | 27 +++++++++++++
>>>>  include/uapi/linux/io_uring.h |  6 ++-
>>>>  io_uring/opdef.c              |  1 +
>>>>  io_uring/uring_cmd.c          | 71 ++++++++++++++++++++++++++++++++++-
>>>>  4 files changed, 103 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
>>>> index cfa6d0c0c322..856d343b8e2a 100644
>>>> --- a/include/linux/io_uring/cmd.h
>>>> +++ b/include/linux/io_uring/cmd.h
>>>> @@ -70,6 +70,21 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
>>>>  /* Execute the request from a blocking context */
>>>>  void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd);
>>>>
>>>> +/*
>>>> + * Select a buffer from the provided buffer group for multishot uring_cmd.
>>>> + * Returns the selected buffer address and size.
>>>> + */
>>>> +struct io_br_sel io_uring_cmd_buffer_select(struct io_uring_cmd *ioucmd,
>>>> +                                           unsigned buf_group, size_t *len,
>>>> +                                           unsigned int issue_flags);
>>>> +
>>>> +/*
>>>> + * Complete a multishot uring_cmd event. This will post a CQE to the completion
>>>> + * queue and update the provided buffer.
>>>> + */
>>>> +bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
>>>> +                                struct io_br_sel *sel, unsigned int issue_flags);
>>>> +
>>>>  #else
>>>>  static inline int
>>>>  io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>>>> @@ -102,6 +117,18 @@ static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
>>>>  static inline void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
>>>>  {
>>>>  }
>>>> +static inline int io_uring_cmd_select_buffer(struct io_uring_cmd *ioucmd,
>>>> +                               unsigned buf_group,
>>>> +                               void **buf, size_t *len,
>>>> +                               unsigned int issue_flags)
>>>> +{
>>>> +       return -EOPNOTSUPP;
>>>> +}
>>>> +static inline bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
>>>> +                               ssize_t ret, unsigned int issue_flags)
>>>> +{
>>>> +       return true;
>>>> +}
>>>>  #endif
>>>>
>>>>  /*
>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>> index 6957dc539d83..1e935f8901c5 100644
>>>> --- a/include/uapi/linux/io_uring.h
>>>> +++ b/include/uapi/linux/io_uring.h
>>>> @@ -298,9 +298,13 @@ enum io_uring_op {
>>>>   * sqe->uring_cmd_flags                top 8bits aren't available for userspace
>>>>   * IORING_URING_CMD_FIXED      use registered buffer; pass this flag
>>>>   *                             along with setting sqe->buf_index.
>>>> + * IORING_URING_CMD_MULTISHOT  must be used with buffer select, like other
>>>> + *                             multishot commands. Not compatible with
>>>> + *                             IORING_URING_CMD_FIXED, for now.
>>>>   */
>>>>  #define IORING_URING_CMD_FIXED (1U << 0)
>>>> -#define IORING_URING_CMD_MASK  IORING_URING_CMD_FIXED
>>>> +#define IORING_URING_CMD_MULTISHOT     (1U << 1)
>>>> +#define IORING_URING_CMD_MASK  (IORING_URING_CMD_FIXED | IORING_URING_CMD_MULTISHOT)
>>>
>>> One other question: what is the purpose of this additional flag?
>>> io_uring_cmd_prep() checks that it matches IOSQE_BUFFER_SELECT, so
>>> could we just check that flag instead and drop the check that
>>> IORING_URING_CMD_MULTISHOT matches REQ_F_BUFFER_SELECT?
>>
>> This is a good question - if we don't strictly needs to exist, eg it
>> overlaps 100% with IOSQE_BUFFER_SELECT, we should just drop it.
> 
> Without this flag, who knows it is one mshot command?
> 
> Other mshot OPs use new OP for showing the purpose, here I just want to
> avoid to add another uring_cmd variant.

Basically all other multishot command types use a flag, not a new
opcode. Read mshot is the odd one out, because it doesn't have private
flags. Hence I do agree with you, the current approach is fine. For some
reason I remembered it as a IO_URING_CMD_* buffer select flag, but it's
not. The other mshot commands also generally require
IOSQE_BUFFER_SELECT, rather than have it be implied by the command type.

-- 
Jens Axboe

