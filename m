Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF3A218F93B
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2020 17:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbgCWQGD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Mar 2020 12:06:03 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33880 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727376AbgCWQGC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Mar 2020 12:06:02 -0400
Received: by mail-pl1-f196.google.com with SMTP id a23so6107609plm.1
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2020 09:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZX5EvtfpCIMdI017WJCJqSuAJdG+LinbMTyemwE82kE=;
        b=ewmCPNhcyf+nUYBOpmfIH9YWAU68C6ZIh7CaCgl/TKSkTxsSWDJWuER4kVp8C6dX3o
         N/k1nXX6C932OpkEIw7XOAsPm9diYJdj6Q3wKLPvDIiTIx1x34OZr8IuiJxfBf2NOD8w
         E2zpCQEgCxkVblt82NTo1zqHjf3kRERrHfnBtKoozqEh6IJORCcT/k8VWxj13PTcOczT
         7QmiVUAAwLYXTXQBmB5NsrY1BQNm3ZTi7wadcvuVAZWfx8ZHh3kfeOVWIPWrJWYw35ej
         llGa+Rnt5OS3M+SCkBvT5po2pXHMjmzaS27poqis3gBDe6dt9lvO6NkG3EG7w/fzuVLi
         HbgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZX5EvtfpCIMdI017WJCJqSuAJdG+LinbMTyemwE82kE=;
        b=Nkv65XG1PsFoC75oDXes5gpKtazdIQ3sSH+7m5i2qHpeP/UcvjffJitKvm/VrGayq/
         pf33/k/cdUX9lzst1n+01Vuh7eRCVv8zQE34Mu9pYKWB7d6/cWrW6gmcP+6eRhtIZOXR
         X3/JrXXflVxRxZYIBob3Rj5ltFahfqmxvWOuGkmSfIboofNaGXft460dlr3ixgZ5ioYi
         zPLi5zmiqAR/PHUW4k60F/SSAsM/xF3McxuLe9Jj5v3Dq2VLVNKJ1dU1yxlqJED9+Gex
         QhcD+dF19hOijeHB9DTqnQdi/YuKOynDqSXNpxUNHAhF/PLHx/Hf/ncpnfJySis2LoCf
         /pIg==
X-Gm-Message-State: ANhLgQ28npqChpCNYkNkcyP83cCsIPI2DAE+qUCryGlTWtTQNhmIq5Yn
        jjLChaE5SMaqiG+C/en55GNOLYB9pttbhg==
X-Google-Smtp-Source: ADFU+vueDSPYJietpjCrQS6zFheIQd9kuIgi0SZRWjBfRLt9YPGL6HMW7CygUvwk8YaORJ8NhrnZ+g==
X-Received: by 2002:a17:902:788b:: with SMTP id q11mr22387120pll.20.1584979560770;
        Mon, 23 Mar 2020 09:06:00 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id q13sm12483314pgh.30.2020.03.23.09.05.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 09:06:00 -0700 (PDT)
Subject: Re: [PATCH] io_uring: refacor file register/unregister/update based
 on sequence
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200323115036.6539-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bf9c7c16-76bb-7fd5-7190-63d8c6bb430a@kernel.dk>
Date:   Mon, 23 Mar 2020 10:05:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200323115036.6539-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/23/20 5:50 AM, Xiaoguang Wang wrote:
> While diving into iouring fileset resigster/unregister/update codes,
> we found one bug in fileset update codes. Iouring fileset update codes
> use a percpu_ref variable to check whether can put previous registered
> file, only when the refcnt of the perfcpu_ref variable reachs zero, can
> we safely put these files, but this do not work well. If applications
> always issue requests continually, this perfcpu_ref will never have an
> chance to reach zero, and it'll always be in atomic mode, also will
> defeat the gains introduced by fileset register/unresiger/update feature,
> which are used to reduce the atomic operation overhead of fput/fget.
> 
> To fix this issue, we remove the percpu_ref related codes, and add two new
> counter: sq_seq and cq_seq to struct io_ring_ctx:
>     sq_seq: the most recent issued requset sequence number, which is
>             protected uring_lock.
>     cq_seq: the most recent completed request sequence number, which is
>             protected completion_lock.
> 
> When we update fileset(under uring_lock), we record the current sq_seq,
> and when cq_seq is greater or equal to recorded sq_seq, we know we can
> put previous registered file safely.

Maybe I'm misunderstanding the idea here, but what if you have the
following:

- sq_seq 200, cq_seq 100

We have 100 inflight, and an unregister request comes in. I then
issue 100 nops, which complete. cq_seq is now 200, but none of the
original requests that used the file have completed.

What am I missing?

-- 
Jens Axboe

