Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF372421AAA
	for <lists+io-uring@lfdr.de>; Tue,  5 Oct 2021 01:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbhJDXeX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 19:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhJDXeW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 19:34:22 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D971C061745
        for <io-uring@vger.kernel.org>; Mon,  4 Oct 2021 16:32:32 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id y17so11760976ilb.9
        for <io-uring@vger.kernel.org>; Mon, 04 Oct 2021 16:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fLdBvk4CrKALk5GZ/pC6C9jLesNQj4l4NnFXFbeN69w=;
        b=67wSaUafE+BcyPKhTlrNUIoHh8eSrKpxOxYiHnrwHqhWqnvSp6dCFdASii1rIlj+6U
         ZSPhuuvjEIheLXr81e4fofYKsbxrt5DLJoe0vMzz+zyozdi+fslGlDzzzSba6Emfrbww
         EYCJYIsptua6WgwUXVdRI7vS9PVgxxEkpvFRR2t90mNIJVAvsw3673Ao9owD+H0JHEO2
         l2AGaD4AzRVJXS2ZvvHxFNtZHZcvGk4ld7pFSomoLDwQ9gkX/ErHns5DcaSuXschS7Rk
         kcW/1cDpZoUE/j1LkCMwAOXoACq08Zg8wnLd7QktTrgWzPWTYt1tTolakVDGnWiuMzdY
         KKCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fLdBvk4CrKALk5GZ/pC6C9jLesNQj4l4NnFXFbeN69w=;
        b=hzY4FrAzCI4KwcJ/4zYlLc7steU/Mg162kjkZqEHpzcv9142TAD94aXI+WVt8uRDs0
         dVMRK3YK8Ljt6L5Qtr5FZKO4lR/lry47Vkz2kvpeIhg1AYirqabh/iNTYemiJdH0lvX+
         VzFJSp3r7MKZYMklkTrg+/fw/iksI6tsUl9sOq3o8SRlgyttDcE7RH8Eoo+CzLYAoiww
         s4nB7RTiNNPa+60pkd1HclHFOw7wJX3u/5BmwzXpwG03OFI6kajC6wBJZ3jdBChkTVC3
         vaCTLwUC39yZOTt+HzfzUqX6WvxsFnCnyQPQ9dnvKRgRSyZdY6Q5rbLegFYGs8dnqC49
         x/Bg==
X-Gm-Message-State: AOAM533OVrGIfP2b9BQChuCbbE7+CUuJg+ZUmbCNS3YblGAg8bsxrPSC
        CJDfDaVbHf5u74zpaO2Fn8kZCL701rIxXg==
X-Google-Smtp-Source: ABdhPJyau7mWekGhYGc1F6HvPkXS4mRvZZ+wdaS+30f5uogmWOZpyg3oKRHFdvCOG+Za0aX8xZlk9w==
X-Received: by 2002:a92:cd8c:: with SMTP id r12mr573601ilb.164.1633390351352;
        Mon, 04 Oct 2021 16:32:31 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id h23sm10682932ila.32.2021.10.04.16.32.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 16:32:30 -0700 (PDT)
Subject: Re: [PATCH v2] liburing: Add io_uring_submit_and_wait_timeout
 function in API
To:     Olivier Langlois <olivier@trillion01.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <1bbde6755535cb7b0bdfc0846254e7c06faf04e0.1633366467.git.olivier@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cceed63f-aae7-d391-dbc3-776fcac93afe@kernel.dk>
Date:   Mon, 4 Oct 2021 17:32:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1bbde6755535cb7b0bdfc0846254e7c06faf04e0.1633366467.git.olivier@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/4/21 10:56 AM, Olivier Langlois wrote:
> before commit 0ea4ccd1c0e4 ("src/queue: don't flush SQ ring for new wait interface"),
> io_uring_wait_cqes() was serving the purpose of submit sqe and wait for cqe up to a certain timeout value.

I fixed up this to wrap at 74 chars (standard style) to avoid wrapping
in git log reading, and fixed up:

> +		if (to_submit < 0)
> +			return to_submit;
>  	}
> +	else
> +		to_submit = __io_uring_flush_sq(ring);
>  
>  	return __io_uring_get_cqe(ring, cqe_ptr, to_submit, wait_nr, sigmask);
>  }
> 

this else condition which was still on a separate line. Applied, thanks.

-- 
Jens Axboe

