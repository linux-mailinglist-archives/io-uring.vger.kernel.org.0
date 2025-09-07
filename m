Return-Path: <io-uring+bounces-9628-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6617B47B59
	for <lists+io-uring@lfdr.de>; Sun,  7 Sep 2025 14:34:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9566E3AF4AA
	for <lists+io-uring@lfdr.de>; Sun,  7 Sep 2025 12:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2BE9212FAA;
	Sun,  7 Sep 2025 12:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e77DOjFP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E631A4E70;
	Sun,  7 Sep 2025 12:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757248444; cv=none; b=NCId45MHfPzY4GO8/P+HAPVJnB4NA5tzeqwdcItp/+ivuU9XjVdjkv9/1IvNlatJ48LhLUYjZENmrI1K7Gt6v6S7zlqbup6qcOoNyeLDRwXSleHzz64STTCx+MuHULf1rqaU0Jh4PQRLOSgXzZDGpuq1q8ndQzAnri3cSzqMwtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757248444; c=relaxed/simple;
	bh=zn4ZBTjGSwPEjnMrT0wztiwBO63BPsZU7Aj/mX2TZfY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QKejDXU1KkDW6rmujSiWwjAo6MeyKVAfQeKBnkRqf/CgESg4Fjn9HgI9zZmHtnzON19QONI8qKCKDmzQSSDQtUZj32CsZb9xj0FgfJ55dh1dakXFy/0P5ib2ziTKCvEh/H4MD8JIg5JoZtWMMMTAs2I3j5AxUdJGiZ4dnMgth/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e77DOjFP; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-55f7ab2a84eso3549269e87.1;
        Sun, 07 Sep 2025 05:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757248441; x=1757853241; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZXoG4GSNwgJ4DS7ZnkRCXmTcDKeh8rWN4WiGCIvyekg=;
        b=e77DOjFPcoVCvq965QaCyrX28OeZyjoYUcd3Otq7Vm8gG8cknN4WQT1UVFrN+6SiYH
         UW5wzdsKWVq0ekx4dqfqo7wHW1Aa6LTnwLRxkFK802+G8JRs3cfR+oG9w+KS4hTAJ6gT
         h8k3vHXKcM5du17qJLN9WNHRendiPeNXLvYa8pvSLcua/pyFWJ/er8QQwc15beBZtbYd
         15DARk3v7szIE/M6HRg/bOUeuoQAVrnEmogpUBavZyjkb1oE/zKGGBGFalSdTLa4ZUQ6
         HcQ7DSdWwU+ofe4DGK8vgZGYP+Pkqab0gzGJShqeSvy+ekjZ2tvWbuiycJdkUmpmXiH1
         EWEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757248441; x=1757853241;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZXoG4GSNwgJ4DS7ZnkRCXmTcDKeh8rWN4WiGCIvyekg=;
        b=R+8FwAKF753tBv28KwzmgRcipjAbVX3+hUt2NtpeKYO7tojhBDi88pf1bR+ZZEjocD
         sr1KxPy8lTHMrmdIFyOhqYx3N5qmbCxO5fFcBD6IAuiRDpqkvMFviZSpcEVZPTs+vKQQ
         yNydJI5dE3tNkiquDyeO2e/LW+FdzvA5++R7KXyx02PYfTYwLS4FY1Y355Lp8AJH2BcT
         0QotIlvziP2MD5pRdSgfxPnfrz3WXmRrBXcS4pxnGtQdsKBT2mNOSdN4gwBYjD98G3cT
         AxcgSjkePsjVKQRIQQ6kLZORCCkCeOiRiw/zugwtB6yNYWxuGbgaBUbIkyZ8+exHSoXf
         SDIA==
X-Forwarded-Encrypted: i=1; AJvYcCVUVNRXddhztBh7WbaLrvyr612X6axcKCepiv0H172KXGuqevrAQuIlzVEkUbYuLwT8sRl5OtKDWQ==@vger.kernel.org, AJvYcCVuTE73dmiQOW0TzYcGD4oP405tBbKinUQiXSBoQInLmaXsss1jHme68jvLfuxaEv8Z/Ex1LvCbQIaBNObx@vger.kernel.org
X-Gm-Message-State: AOJu0YyXj+6sb12RD+JDdW1q5K/MbspH1eYixCL1RjWye4EsvWdjDeW3
	hBhd05bazYG2stX6VgyTFw/ABfGkRIgoV4e1ICiJ7srsuHOBBUpQOCyP
X-Gm-Gg: ASbGncsoOK4KmHosXJvZp4pGvUqSNGRP5As2q9cpYp65OtzGfjwHY+M/yMM1Y5k49OH
	z5G4iE0m2VOS3GKz0U44rx8rU4IMa01yn9Ip7gzLGa0jEdRHpm1lbBpGJsNpkSzBPucJE83EmUa
	qNNi9KcwSdCR5k3SEMSXhclbyEekifq7gv6Bdn0+dNOVOd6aOoYyml23CPj+mp2ZtwOQMnyp1yo
	7NuiD2ul4L7mEmxywd4Z8g6IntrXdGF76awxmmF4UckwZWiRk4m66bxBKKg3w/iWZDNzd+q+ekr
	x4R6uh2tBiXHBZH7cEwbkorCDd2jhJXCJYd/YPrCKuIipk7ZfvEuDvohzvLam+Yqc49cyFks6kG
	ek+blvb30QZn2cFKwggyAsww2kLWYKBn0K2KDllgKxnZpaZao9Jz4YFh/Qg==
X-Google-Smtp-Source: AGHT+IEf3gtmoULRDtv5lJFyt0L0At5zNku7nJpb5Deg2eT2OfEnwn3sLpVMYoqWzV6WsMFIiFv+KA==
X-Received: by 2002:a05:6512:10ca:b0:55f:5942:43ca with SMTP id 2adb3069b0e04-56260f37a43mr1444609e87.20.1757248441032;
        Sun, 07 Sep 2025 05:34:01 -0700 (PDT)
Received: from localhost (soda.int.kasm.eu. [2001:678:a5c:1202:4fb5:f16a:579c:6dcb])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-5608acfc24fsm2880467e87.104.2025.09.07.05.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Sep 2025 05:34:00 -0700 (PDT)
Date: Sun, 7 Sep 2025 14:33:59 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] io_uring/uring_cmd: add io_uring_cmd_tw_t type alias
Message-ID: <3h5wdobeinxy7bbhvw3aztcns33cea3irxg4ckwvmds56ynyi4@45fy2e3uemz2>
References: <20250902160657.1726828-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902160657.1726828-1-csander@purestorage.com>

Hi,

On 2025-09-02 10:06:56 -0600, Caleb Sander Mateos wrote:
> Introduce a function pointer type alias io_uring_cmd_tw_t for the
> uring_cmd task work callback. This avoids repeating the signature in
> several places. Also name both arguments to the callback to clarify what
> they represent.
> 
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> ---
>  include/linux/io_uring/cmd.h | 13 ++++++++-----
>  io_uring/uring_cmd.c         |  2 +-
>  2 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index 4bd3a7339243..7211157edfe9 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -9,15 +9,18 @@
>  /* only top 8 bits of sqe->uring_cmd_flags for kernel internal use */
>  #define IORING_URING_CMD_CANCELABLE	(1U << 30)
>  /* io_uring_cmd is being issued again */
>  #define IORING_URING_CMD_REISSUE	(1U << 31)
>  
> +typedef void (*io_uring_cmd_tw_t)(struct io_uring_cmd *cmd,
> +				  unsigned issue_flags);
> +
>  struct io_uring_cmd {
>  	struct file	*file;
>  	const struct io_uring_sqe *sqe;
>  	/* callback to defer completions to task context */
> -	void (*task_work_cb)(struct io_uring_cmd *cmd, unsigned);
> +	io_uring_cmd_tw_t task_work_cb;
>  	u32		cmd_op;
>  	u32		flags;
>  	u8		pdu[32]; /* available inline for free use */
>  };
>  
> @@ -55,11 +58,11 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
>   */
>  void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, u64 res2,
>  			unsigned issue_flags);
>  
>  void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
> -			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
> +			    io_uring_cmd_tw_t task_work_cb,
>  			    unsigned flags);
>  
>  /*
>   * Note: the caller should never hard code @issue_flags and only use the
>   * mask provided by the core io_uring code.
> @@ -104,11 +107,11 @@ static inline int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
>  static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
>  		u64 ret2, unsigned issue_flags)
>  {
>  }
>  static inline void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,

> -			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
> +			    io_uring_tw_t task_work_cb,

There seems to have slipped in a typo for the !IO_URING stub here:
s/io_uring_tw_t/io_uring_cmd_tw_t/

>  			    unsigned flags)
>  {
>  }
>  static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
>  		unsigned int issue_flags)

...

Regards,
Klara Modin

