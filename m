Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270602E80C7
	for <lists+io-uring@lfdr.de>; Thu, 31 Dec 2020 16:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgLaPH3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 31 Dec 2020 10:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgLaPH3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 31 Dec 2020 10:07:29 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E6BC061573
        for <io-uring@vger.kernel.org>; Thu, 31 Dec 2020 07:06:48 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 30so8503637pgr.6
        for <io-uring@vger.kernel.org>; Thu, 31 Dec 2020 07:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YuK8beX3Xt4aqjGUqq5Cz//9NLzVoZMYn3FoVQHi/tw=;
        b=vCevkNGbd1RNvQ3q1B4/Rs6V4b8vYsI/f+HdH1ib1girbSPPTU9hLbXxjSZZclDYYG
         5eDvafNo55zCUmQrxx/wueFGfOhHRxX42odEjRed6AYaORORE4UHffpn8gQ+ebqSaNM8
         JWRaA13UYZZu4WvBvQHwzg3b8jSYTYFgowqN5bR9JEcxvc0S32C3g1bA8m4LcOMPid2t
         emqVBtWxuvTjG2fPWQlWSjTetFiJucwpmq1GeX5/A1jgwUDxR10cslX3bDz6kggGO1YZ
         VK+IXNfiloCBoiNCejjd1j7pGavLznc/5J0eHb7B7zVmmPMD79OuXJkdTIHoFNf/qBfe
         IqpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YuK8beX3Xt4aqjGUqq5Cz//9NLzVoZMYn3FoVQHi/tw=;
        b=BgN2zbyLMrE0NC684eEWZ/91v02ruIuuBZyhTVgwNTWAqFpPKrpouxjvBie13fNOwp
         shGDhZCnqOikii4jvYmiWuppam7iujCWUesCrpjgTQ4d973WGGO2HviEjgccv2nCKSCS
         VZatLtV1L5HoZZSn1o7CN/7AcbAfZSIcCNv8w2DMLo22qHd76RI0mxGpoheaOQx7uHGB
         U0H/XcxCWKRQs4PrrKpXb4ylbs16HNiFdswhQMceJJg4eO07n/MOMkE4R5ByuMyOTqYw
         vNlCfTGxl+z/Cjii4tdToZg8g8B9suimooFv17vmp0kQ9QhPIIzF9ysd3iJgjMTQzMtJ
         2/XQ==
X-Gm-Message-State: AOAM532pEb1gDgLhB3p5G5FPP8bXQ5GqSzp0ZIJMKof09/s053UFAwzZ
        ac1iCIbObZ6s5FNsVjig0HVltQ==
X-Google-Smtp-Source: ABdhPJyhISMBPw/PzuL6ar6qOnd4Ws6wJA3P2dV6vlsJQGblKndt7RkceH49cyLHBKzQt4X1O3aiyw==
X-Received: by 2002:a63:3648:: with SMTP id d69mr56945248pga.155.1609427208291;
        Thu, 31 Dec 2020 07:06:48 -0800 (PST)
Received: from ?IPv6:2603:8001:2900:d1ce:198f:c3ce:c557:4355? (2603-8001-2900-d1ce-198f-c3ce-c557-4355.res6.spectrum.com. [2603:8001:2900:d1ce:198f:c3ce:c557:4355])
        by smtp.gmail.com with ESMTPSA id k64sm47180571pfd.75.2020.12.31.07.06.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Dec 2020 07:06:47 -0800 (PST)
Subject: Re: [PATCH 4/4] io_uring: cancel requests enqueued as task_work's
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <cover.1609361865.git.asml.silence@gmail.com>
 <9d7a1c5ce3fe2a6054382760b9ef68f03c6e11ba.1609361865.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e7a576e6-972e-28c1-8429-500330efce38@kernel.dk>
Date:   Thu, 31 Dec 2020 08:06:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9d7a1c5ce3fe2a6054382760b9ef68f03c6e11ba.1609361865.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/30/20 2:34 PM, Pavel Begunkov wrote:
> Currently request cancellations are happening before PF_EXITING is set,
> so it's allowed to call task_work_run(). Even though it should work as
> it's not it's safer to remove PF_EXITING checks.
> 
> Cc: stable@vger.kernel.org # 5.5+
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index ca46f314640b..8d4fa0031e0a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2361,12 +2361,8 @@ static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
>  
>  static inline bool io_run_task_work(void)
>  {
> -	/*
> -	 * Not safe to run on exiting task, and the task_work handling will
> -	 * not add work to such a task.
> -	 */
> -	if (unlikely(current->flags & PF_EXITING))
> -		return false;
> +	WARN_ON_ONCE(current->flags & PF_EXITING);

Should still include the return, ala:

if (WARN_ON_ONCE(current->flags & PF_EXITING))
	return;

to be on the safe side, otherwise it'll crash anyway if we do hit this
condition.

-- 
Jens Axboe

