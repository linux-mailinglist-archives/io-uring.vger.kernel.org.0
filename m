Return-Path: <io-uring+bounces-9176-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CEE8B30051
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 18:44:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E10BB16901E
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 16:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57AB52E11CA;
	Thu, 21 Aug 2025 16:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XPD3XggY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F68B2E0B5B
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 16:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755794341; cv=none; b=ADqxNxMkzD47z0TpiocqX2BmaJHVLBRUwQsfTRFBPsgbPA2f3BhBZ2hoFAu8iljjP8txyTf3sF8IRLbqgBIbKaMi9RN4mSMfAHrPJbE7h3B72vmkkMBrsT8d+1jhnmjG2AFwiAYaLzNnQsaeKCSUxNwy2KCrcfAB1KgkN+Bjp50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755794341; c=relaxed/simple;
	bh=hTcOmcV9UqdRYNAN826yorV7BiAnrpT2woinpxyvVyo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cov6MmFoYgHOJG+6IrsvA1W0tLU/m7dJq1qZ0b6sv54OMDsKGcMWzGlBg+KD78ezK7zqrF/wplVmHdFYezN3/e+ZReA1gZagPIaWB4JS0gjxMx0Lx/+ldGQCuTFzVYsLGCc/M3AbIgrtZdnW7c7erCp0TwlTbSdO/Vq832pV99M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XPD3XggY; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3e56fe7a3d6so9186545ab.0
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 09:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755794338; x=1756399138; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=13dHUDz5mogpLbgywjZtexAumYt/N5kjW4KmB7uWvIk=;
        b=XPD3XggYPTzhfJ98MICcDMfAbXHQEsVmxFYWFHZw3JymANY+esw3HC5zhbUT1s/DVu
         HSyNT1H1s5GVxmDU8IBrG0kDQ49RSjqH8K5pINtgSlYs4vAU/j9yYeS/3+Pc//FZRSf9
         rLABACeO198itsa39N14FTjueoF4l166YabAsxM0pCxA0wwqs86Gdu1b+4lCgduLK2Wd
         +TIznTDQQlobShFlxPOQAo6IPJK5yxqvoEJQpFI3ipWAWs8s7m8ppL00SypBmx05kNwx
         sbzryq5BmmZqRELrd0wn5jwcpx8lrMCuejDUsxQbmYs0Pjm3iIiUUYt6PPrDG0JXiClb
         1efw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755794338; x=1756399138;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=13dHUDz5mogpLbgywjZtexAumYt/N5kjW4KmB7uWvIk=;
        b=JUJSCt6TQcuL5HnadARplT/Gbh4ULSLwf6YWaWQ9Ws1CNZ0h54dGLPbmeIf3o/5Pie
         j1RNvEjdy+TEI9isVcsSN66rrZmSu7mIWOtkgTE2B/QykPwzw0cW+1xNbyZ4fpb6nS8l
         vG8orF1+wAq7hZexrtc+NxM2sTvHvU6Fav1hkZSLctAtzN3nEzaf0VsESL2GWXrxvXzP
         cGzTleyN+N3CuheNtq0aWRDM+mlxXtCZGSHjsWtfAk/4IAfNp77iA7bcxc/a91y/JUa+
         5IBny7qfppIMKycangefbk2245nc/QMcL+Q1vrGAqqCGUFfC+H7o9UoavkMLL0r4rj9l
         3CtQ==
X-Gm-Message-State: AOJu0YwVVqsXyjSyU7FZBjP0gjbH0S3ni7ySRTa+XZrdiIAyYt0cZ8+H
	N9yKR/UMtMRwyT19eB744lf6YCFqBCahkT3X7a+O19OdkaOyk3qKyfi1CstnTzVD7TE=
X-Gm-Gg: ASbGncuWRusuDJl7Tvnt6UxgEwuUI0VT8hEkD6vraZXo+kjYI6UF605SB1a8KCf91Pd
	fSsEFWQzjf5f2qdiVlvwQ3+I8Tr77CkSSMbphGMr96WSBdaIGodLC5GT9iABnciujOuVEgzmAI4
	kT2qsYulquGg7wPmTY0R08bhxXKmMl62mTdDhCgFPAGJ7kVccJa9c1S1wgXpgO0Nyn+8Gr+C1yN
	YJUR/OBuGsF5+32XPyjdFKRTymhDpU3LiYbC6AlsEsUnOVM5oT95U0JJOb0ohOpSztECmJcRQD7
	Rcon7jnJvJu9oq9Bt6UdBUC2+V05k+6zGWoiYUF9nSj6zuruigCGEpMmqMOAN9XTgbS0O74+hdH
	l1jQTxvePki6nzfVcnIU=
X-Google-Smtp-Source: AGHT+IHUkWvKID/INZPwkULR+smiCCJpLGP8IECDeFZMxlSS05D4sMgHR8afm4vZTbGvGbXFNlb+aw==
X-Received: by 2002:a05:6e02:194e:b0:3e5:7dac:d690 with SMTP id e9e14a558f8ab-3e922125110mr212365ab.19.1755794338489;
        Thu, 21 Aug 2025 09:38:58 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e699e569a4sm16349285ab.0.2025.08.21.09.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 09:38:57 -0700 (PDT)
Message-ID: <a9d16693-b52e-42c7-97aa-52484e4ce510@kernel.dk>
Date: Thu, 21 Aug 2025 10:38:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 2/2] io_uring: uring_cmd: add multishot support
To: Caleb Sander Mateos <csander@purestorage.com>,
 Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
References: <20250821040210.1152145-1-ming.lei@redhat.com>
 <20250821040210.1152145-3-ming.lei@redhat.com>
 <CADUfDZrUUZzhMw4z=Q0U7PAzp+0Aj_=NNyY6kJH21uQL36B-Fw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZrUUZzhMw4z=Q0U7PAzp+0Aj_=NNyY6kJH21uQL36B-Fw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/21/25 10:29 AM, Caleb Sander Mateos wrote:
> On Wed, Aug 20, 2025 at 9:02?PM Ming Lei <ming.lei@redhat.com> wrote:
>>
>> Add UAPI flag IORING_URING_CMD_MULTISHOT for supporting multishot
>> uring_cmd operations with provided buffer.
>>
>> This enables drivers to post multiple completion events from a single
>> uring_cmd submission, which is useful for:
>>
>> - Notifying userspace of device events (e.g., interrupt handling)
>> - Supporting devices with multiple event sources (e.g., multi-queue devices)
>> - Avoiding the need for device poll() support when events originate
>>   from multiple sources device-wide
>>
>> The implementation adds two new APIs:
>> - io_uring_cmd_select_buffer(): selects a buffer from the provided
>>   buffer group for multishot uring_cmd
>> - io_uring_mshot_cmd_post_cqe(): posts a CQE after event data is
>>   pushed to the provided buffer
>>
>> Multishot uring_cmd must be used with buffer select (IOSQE_BUFFER_SELECT)
>> and is mutually exclusive with IORING_URING_CMD_FIXED for now.
>>
>> The ublk driver will be the first user of this functionality:
>>
>>         https://github.com/ming1/linux/commits/ublk-devel/
>>
>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>> ---
>>  include/linux/io_uring/cmd.h  | 27 +++++++++++++
>>  include/uapi/linux/io_uring.h |  6 ++-
>>  io_uring/opdef.c              |  1 +
>>  io_uring/uring_cmd.c          | 71 ++++++++++++++++++++++++++++++++++-
>>  4 files changed, 103 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
>> index cfa6d0c0c322..856d343b8e2a 100644
>> --- a/include/linux/io_uring/cmd.h
>> +++ b/include/linux/io_uring/cmd.h
>> @@ -70,6 +70,21 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
>>  /* Execute the request from a blocking context */
>>  void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd);
>>
>> +/*
>> + * Select a buffer from the provided buffer group for multishot uring_cmd.
>> + * Returns the selected buffer address and size.
>> + */
>> +struct io_br_sel io_uring_cmd_buffer_select(struct io_uring_cmd *ioucmd,
>> +                                           unsigned buf_group, size_t *len,
>> +                                           unsigned int issue_flags);
>> +
>> +/*
>> + * Complete a multishot uring_cmd event. This will post a CQE to the completion
>> + * queue and update the provided buffer.
>> + */
>> +bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
>> +                                struct io_br_sel *sel, unsigned int issue_flags);
>> +
>>  #else
>>  static inline int
>>  io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>> @@ -102,6 +117,18 @@ static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
>>  static inline void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
>>  {
>>  }
>> +static inline int io_uring_cmd_select_buffer(struct io_uring_cmd *ioucmd,
>> +                               unsigned buf_group,
>> +                               void **buf, size_t *len,
>> +                               unsigned int issue_flags)
>> +{
>> +       return -EOPNOTSUPP;
>> +}
>> +static inline bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
>> +                               ssize_t ret, unsigned int issue_flags)
>> +{
>> +       return true;
>> +}
>>  #endif
>>
>>  /*
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index 6957dc539d83..1e935f8901c5 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -298,9 +298,13 @@ enum io_uring_op {
>>   * sqe->uring_cmd_flags                top 8bits aren't available for userspace
>>   * IORING_URING_CMD_FIXED      use registered buffer; pass this flag
>>   *                             along with setting sqe->buf_index.
>> + * IORING_URING_CMD_MULTISHOT  must be used with buffer select, like other
>> + *                             multishot commands. Not compatible with
>> + *                             IORING_URING_CMD_FIXED, for now.
>>   */
>>  #define IORING_URING_CMD_FIXED (1U << 0)
>> -#define IORING_URING_CMD_MASK  IORING_URING_CMD_FIXED
>> +#define IORING_URING_CMD_MULTISHOT     (1U << 1)
>> +#define IORING_URING_CMD_MASK  (IORING_URING_CMD_FIXED | IORING_URING_CMD_MULTISHOT)
> 
> One other question: what is the purpose of this additional flag?
> io_uring_cmd_prep() checks that it matches IOSQE_BUFFER_SELECT, so
> could we just check that flag instead and drop the check that
> IORING_URING_CMD_MULTISHOT matches REQ_F_BUFFER_SELECT?

This is a good question - if we don't strictly needs to exist, eg it
overlaps 100% with IOSQE_BUFFER_SELECT, we should just drop it.

-- 
Jens Axboe

