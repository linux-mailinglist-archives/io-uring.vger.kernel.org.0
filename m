Return-Path: <io-uring+bounces-10013-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DD385BDB0D5
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 21:25:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A95A04EAB93
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 19:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A5F11F63F9;
	Tue, 14 Oct 2025 19:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m7RobHky"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83BD246BDE
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 19:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760469939; cv=none; b=M7XjhA2cvcsnkzE3i3CnE8hChOS8iRoxN2TKVXLH190mpll0Ou/uLXJQjwV/xKSzgwdrO2zhIWXGvgg6EwINxWJiW53MiQfkW2iga/zt0cDVYDT7UHkQ6JQ6dLnrcBu/FlZn/gr9HHzakY0SRXyhCRUk7M/xuycuvfzKYzVBeu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760469939; c=relaxed/simple;
	bh=H+jE4lMo+tIImj+EiGgGyV3L0fI0zmpl0OaNsQxSy04=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VkmbOBu5oaBHdd8CehQUFmIdB6fpLEQiZbHG/HlRSfqUWLG8467X8PmlD8lBx1HltZzqXrIv7nOb3JAxCrOKFbykE4OcxgJBbRIiuRVYTt5dDTL7+XM0h8LXfad7zcdSlD5qtkWpCq/ueh8xfalIfS1sm3hKPhh+xNpDg8DoJhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m7RobHky; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-46e3a50bc0fso42702325e9.3
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 12:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760469936; x=1761074736; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=90VotXpSXt2/AzakLm5Gb3rz7/IZyqGcHjIO7e9poR8=;
        b=m7RobHkyo3DCh4imU+hYX26Ow7ximtQHhCqyYoZoQJwugoSwBDcJeIhzNUMF0COccs
         WryEKn1oMpydH1tk3yk7pM26WnxMfs4CflYzcO9a3Q9ZA05TsOtUJ5y//m1AZ56RwAHL
         41gtSapQpVVmB381/vOixYO6GCDwD+TXpp5EPtwWmT1UDfioDPLR0TpjgZ1tu3U0DsrL
         cvzqyPOdHJSbWOfL9mAHqiLyZ6holE+MyEF97xu6IXABrtQplFRDaOd8zhu7qV2b5MYU
         mZLzCQunp3lsEG/T2RV50coHqvRP7T8v8yNMaKpzUqvz2QZj4RJFgBh24VgYmJmIojEN
         tK1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760469936; x=1761074736;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=90VotXpSXt2/AzakLm5Gb3rz7/IZyqGcHjIO7e9poR8=;
        b=lNKpUtGJ2/0ouH+tzcZs/zMtfHPI5R3CZ9fEXFbgJ5t8UnW/Up1gyVb3NEW9JCsFxy
         TVBjEuXqBL3f2gaqeo9HwW6jcy9YNOWnfgfAdpEjydMLhfHJSft//4EE3t6GcYyou8Ey
         prJtZcYTPit/+hJILavGcgjg4jGNKrtb0MZYkLPL2QANIsNwdTnD9pan8tZOVI+jZBm3
         ITYsAk7s1rPpyZIF3q56Kvf6+UApgWnjfW8QOOWNrreE+Rp5YEGl7X6T+VEjjfJSoq7Y
         6fEW6Q4BBoYeKf79aP+oG+n/9wpiumxgFkOecB9mkI0CGezJk5CLuM032soSYbvjbQHt
         Igsg==
X-Gm-Message-State: AOJu0YxXYCGWAbzrtW2vWPf/AILFVQArzCALpzmwPBBQ2cS/9oJBGzOO
	hfQntHtDCDc03VEiDa/Hvxx/kIeM4gnVorVtUELKHMQMNvKh66ylEb8E
X-Gm-Gg: ASbGncv98kGipj01iVYN6qQ+PgrIJFt9dII4Jt0a7/S/uVzEe8nGJKWrKNj6eBJBQIo
	TM1VnQ0Jz6U2bxcl3CRkn1RWjV3BJISh1MT0v/JKUemFAAVkl3F6wtcsmBY1fBT3kyxtiGy+iZx
	QWK9iIvULvg75Ayd2/zBsXjrckQv36rzuuQEgLUBqL0/Vdut994AcCvTZ+F1B7P4GblCOK2Dv8F
	9MbBiJxGENMBZAnhvKnHDEJBOqoR2FNnK7v2v5FIpWvIt0TknHibco+ibWuPZ4bM908eqsA1B4M
	4H5VvHImpu/kUh3kVo7YDi34BLzwJNMK5+iwmgLw3tejXR0OB4TLI7TomApF2cz+S5AhaDHrlEB
	gTXeoyybLZLZkf9unLE5uN/Ge1EXfv6TVOD+mUUFTPHGWnC5DT5hg37LqK0dZTFtPMzUIORVmDY
	c9OwAW9z/ZapS0EIPOciThN49PMhw=
X-Google-Smtp-Source: AGHT+IFJ0RbckPhfQ+EdkD2crlpbSbubMVzlY/6uQQtKjrStYBhnJkKuCuHB0Ol1cAyCb5wXALmf9Q==
X-Received: by 2002:a05:6000:2010:b0:425:8253:b0e5 with SMTP id ffacd0b85a97d-42667083755mr16737251f8f.20.1760469935696;
        Tue, 14 Oct 2025 12:25:35 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce583316sm24955041f8f.20.2025.10.14.12.25.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 12:25:34 -0700 (PDT)
Message-ID: <fdff4e0c-0d26-4e19-8671-1f98e1c526a6@gmail.com>
Date: Tue, 14 Oct 2025 20:26:56 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring: introduce non-circular SQ
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org
References: <cover.1760438982.git.asml.silence@gmail.com>
 <d2cb4a123518196c2f33b9adfad8a8828969808c.1760438982.git.asml.silence@gmail.com>
 <CADUfDZqXmmG+_9ENc6tJ4RRQ5L4_UKhWxZd3O5YGQP7tNo2iHg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADUfDZqXmmG+_9ENc6tJ4RRQ5L4_UKhWxZd3O5YGQP7tNo2iHg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/14/25 19:37, Caleb Sander Mateos wrote:
> On Tue, Oct 14, 2025 at 3:57 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
...>> + * SQEs always start at index 0 in the submission ring instead of using a
>> + * wrap around indexing.
>> + */
>> +#define IORING_SETUP_SQ_REWIND         (1U << 19)
> 
> Keith's mixed-SQE-size patch series is already planning to use this
> flag: https://lore.kernel.org/io-uring/20251013180011.134131-3-kbusch@meta.com/

I'll rebase it as ususual if that gets merged before.
>> -       /*
>> -        * Ensure any loads from the SQEs are done at this point,
>> -        * since once we write the new head, the application could
>> -        * write new data to them.
>> -        */
>> -       smp_store_release(&rings->sq.head, ctx->cached_sq_head);
>> +       if (ctx->flags & IORING_SETUP_SQ_REWIND) {
>> +               ctx->cached_sq_head = 0;
> 
> The only awkward thing about this interface seems to be if
> io_submit_sqes() aborts early without submitting all the requested
> SQEs. Does userspace then need to memmove() the remaining SQEs to the
> start of the ring? It's certainly an unlikely case but something
> userspace has to handle because io_alloc_req() can fail for reasons
> outside its control. Seems like it might simplify the userspace side
> if cached_sq_head wasn't rewound if not all SQEs were consumed.
This kind of special rules is what usually makes interfaces a pain to
work with. What if you want to abort all un-submitted requests
instead? You can empty the queue, but then the next syscall will
still start from the middle. Or what if the application wants to
queue more requests before resubmitting previous ones? There are
reasons b/c the kernel will need to handle it in a less elegant way
than it potentially can otherwise. memmove sounds appropriate.

>> @@ -3678,6 +3687,12 @@ static int io_uring_sanitise_params(struct io_uring_params *p)
>>   {
>>          unsigned flags = p->flags;
>>
>> +       if (flags & IORING_SETUP_SQ_REWIND) {
>> +               if ((flags & IORING_SETUP_SQPOLL) ||
>> +                   !(flags & IORING_SETUP_NO_SQARRAY))
> 
> Is there a reason IORING_SETUP_NO_SQARRAY is required? It seems like
> the implementation would work just fine with the SQ indirection ring;
> the rewind would just apply to the indirection ring instead of the SQE
> array. The cache hit rate benefit would probably be smaller since many
> more SQ indirection entries fit in a single cache line, but I don't
> see a reason to explicitly forbid it.

B/c I don't care about sqarray setups, they are on the way out for soft
deprecation with liburing defaulting to NO_SQARRAY, and once you try
to optimise the kernel IORING_SETUP_SQ_REWIND handling it might turn
out that !NO_SQARRAY is in the way... or not, but you can always allow
it later while limiting it would break uapi. In short, it's weighting
chances of (micro) optimisations in the future vs supporting a case
which is unlikely going to be used.

-- 
Pavel Begunkov


