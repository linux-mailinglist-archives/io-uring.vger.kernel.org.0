Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D982A1329
	for <lists+io-uring@lfdr.de>; Sat, 31 Oct 2020 03:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgJaCy5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Oct 2020 22:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgJaCy5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Oct 2020 22:54:57 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F704C0613D5
        for <io-uring@vger.kernel.org>; Fri, 30 Oct 2020 19:54:57 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id i26so6684840pgl.5
        for <io-uring@vger.kernel.org>; Fri, 30 Oct 2020 19:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=og+jD3drvTt7V54qVhh83PMU6fOB9+0lUufI99xQigs=;
        b=E2SCOoq6xoswHNwVywOeHyIcAkyvos9iaNPTGPVx++yl8JugAeqXQglL7dfMeLtLuf
         POQZZd4WAsAOa/kR1KW5jRjOWFY9fXz1IecghRZYXESZs7dOb8mQCublXuliA0kQqCAe
         e4YT8zkL6TqkfbUAAVXklG5c2ZbHtVyOsp5ZUzhS130pqVW3r+wYXlGkJsY3On7e+Cha
         F91XRNvFOUk4uY/gsx6BYdkC8yGjpGXkr12MzvNCRdOB4BQZsuGY0937CCHNAS6SywEt
         OCzaUDDRUAimjZgGTTGzohDG6BAxcA/sPIkB4K5Zl5Rxp9p2ypaU/pkbI6BxI5Efd3c6
         i/4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=og+jD3drvTt7V54qVhh83PMU6fOB9+0lUufI99xQigs=;
        b=Q7SV42r/++GwC1BCoM61F2XXvZuCsvdeZhO54QifMe6JILIQnkmm07+swzhFfWwfbc
         h8hi2nLuBAJo0L2QYDhKH4LMBrW8Ci1zfR+xGJAvp8na1C41cAWI4x9vPAeGaLYm5IyA
         2jhHklzBF/qLXzBm8c+WkbP04qDXnZDR0bXS6L50GWcWqdX6g7qCYttxJNsC4479MCX/
         exkKkflX3QSoy3eaEAyFr3ClUMKdpZEchbOM09j9NVDJpukQcEiRFYv6xf8uXWT3wYqV
         eGV5309DExpymQycf3RvnI4amHsRKSYeJaFqb2xCsSbwVOyjhPTTHRn9Crlu3iunWPfE
         Zgcw==
X-Gm-Message-State: AOAM532hkw8ir6tIDmaOdADwiNdmks+2s3lYIaH+kWvxWz0LUaM4UExk
        1BkiXtJjpr/AtxMHv7e/4+Csy+PS35Ql+A==
X-Google-Smtp-Source: ABdhPJykHZlH+ZYdtDUt2kMgzgscc6huyOV/3nyJ2S5LbnlFkuH5SCnBilDq7h2CL4H/gYdaZptghQ==
X-Received: by 2002:a65:628f:: with SMTP id f15mr4834724pgv.168.1604112896696;
        Fri, 30 Oct 2020 19:54:56 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id e23sm6912119pfi.191.2020.10.30.19.54.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 19:54:55 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: add timeout support for io_uring_enter()
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, metze@samba.org
References: <1596533282-16791-1-git-send-email-jiufei.xue@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2c344984-3534-eb32-d2a2-964221cbd070@kernel.dk>
Date:   Fri, 30 Oct 2020 20:54:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1596533282-16791-1-git-send-email-jiufei.xue@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/4/20 3:28 AM, Jiufei Xue wrote:
> @@ -6569,7 +6578,14 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>  		}
>  		if (io_should_wake(&iowq, false))
>  			break;
> -		schedule();
> +		if (uts) {
> +			if ((timeout = schedule_timeout(timeout)) == 0) {
> +				ret = -ETIME;
> +				break;
> +			}

Please don't combine lines, this is a lot more readable as:

timeout = schedule_timeout(timeout);
if (!timeout) {
	...
}

> @@ -7993,19 +8009,36 @@ static unsigned long io_uring_nommu_get_unmapped_area(struct file *file,
>  #endif /* !CONFIG_MMU */
>  
>  SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
> -		u32, min_complete, u32, flags, const sigset_t __user *, sig,
> +		u32, min_complete, u32, flags, const void __user *, argp,
>  		size_t, sigsz)
>  {
>  	struct io_ring_ctx *ctx;
>  	long ret = -EBADF;
>  	int submitted = 0;
>  	struct fd f;
> +	const sigset_t __user *sig;
> +	struct __kernel_timespec __user *ts;
> +	struct io_uring_getevents_arg arg;
>  
>  	io_run_task_work();
>  
> -	if (flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP))
> +	if (flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
> +		      IORING_ENTER_GETEVENTS_TIMEOUT))
>  		return -EINVAL;
>  
> +	/* deal with IORING_ENTER_GETEVENTS_TIMEOUT */
> +	if (flags & IORING_ENTER_GETEVENTS_TIMEOUT) {
> +		if (!(flags & IORING_ENTER_GETEVENTS))
> +			return -EINVAL;
> +		if (copy_from_user(&arg, argp, sizeof(arg)))
> +			return -EFAULT;
> +		sig = arg.sigmask;
> +		ts = arg.ts;
> +	} else {

I like the idea of the arg structure, but why don't we utilize the
size_t argument for that struct? That would allow flexibility on
potentially changing that structure in the future. You can use it for
versioning, basically. So I'd require that to be sizeof(arg), and the
above should then add:

	if (flags & IORING_ENTER_GETEVENTS_TIMEOUT) {
		if (!(flags & IORING_ENTER_GETEVENTS))
			return -EINVAL;
		if (sigsz != sizeof(arg))
			return -EINVAL;
		...

> @@ -290,4 +292,9 @@ struct io_uring_probe {
>  	struct io_uring_probe_op ops[0];
>  };
>  
> +struct io_uring_getevents_arg {
> +	sigset_t *sigmask;
> +	struct __kernel_timespec *ts;
> +};
> +

This structure isn't the same size on 32-bit and 64-bit, that should be
rectified. I'd make the sigmask a u64 type of some sort.

So little things - but please resend with the suggested changes and we
can move forward with this patch for 5.11.

-- 
Jens Axboe

