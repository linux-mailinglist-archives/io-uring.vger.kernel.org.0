Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A5B1E91D2
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2020 15:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgE3Nuq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 May 2020 09:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgE3Num (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 May 2020 09:50:42 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1025AC08C5CA
        for <io-uring@vger.kernel.org>; Sat, 30 May 2020 06:50:41 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id q24so2716104pjd.1
        for <io-uring@vger.kernel.org>; Sat, 30 May 2020 06:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ubhL8BFn+yo4pHtTd6U6Xpnq8CDrnGMLha9n6Te9Nlo=;
        b=lEBn1695cvRsGzNS4ix8zG4MkKm5RfjPwRK117vs2jLE+2dvkmo5lv4QTAE6f0JEUY
         oNg4bLeiNqcCIzTEn8imuptjV/CAR4WSmUJR/7NAzfCmP0JE51mJ2t2yplZoHrUE+t3c
         yJ9ZogkItkTr+/fI4hZcVwlvquRP/HAPFlp/wftMQU1xv4bulk97oFRwwC4USo/QRWke
         Cn1CupH6o+UnKPLkXzy4zE88eAHBS3OzcNtls+ArL/Yk2g7wKk96ze0ALIX13yUapL6Y
         YtANtmnVYKgR3qE794Yb1PWHp4B1jOTmO+5wuKqlmq1iIqkb0xEezo6op0Tb9jvW8FSF
         iKbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ubhL8BFn+yo4pHtTd6U6Xpnq8CDrnGMLha9n6Te9Nlo=;
        b=HFE6mJvSJhauYCWwb1fNn5Su50ohfxnh1MwEXFdzuhls2vti9bkf0rAB2DpvPvqKWh
         mQ5luDALIho/7SKm1+q/UJhkMJeClIZg2Gmln2Rjkj9cNvpTnJmrJvZL1oITvll6Rdrt
         6GoR4frEPuk94K5+aIDuMNaJKjim2NuzPg4QUTmMt7Po0BzPtp6iMMtuGTAetUJjjH5/
         6t2xvxUiVS7CdADAvX3AEIngypdNlNK0yAd5GUF9bOf56k99kUZsAZM5KcyWiAQmfsmV
         vQD5jVZ7alR6vszWCWBvgdV46X+1flVIDkREEC8pl7l+xm/g2k/os3Oirhwi3OSvLDn7
         fLVA==
X-Gm-Message-State: AOAM531N6Io3rqt7MZDcpWvUumzUEr52wrP4Ri33LNrUklnGUnFGJZ2V
        cVgYxCJIEdlSSSn2v1/1+3jPNQ==
X-Google-Smtp-Source: ABdhPJwvCsAMuoQC1TsuE65TV/BnLzTRO41b/Hqb4BTIHGlrgvM5jc98itr2hioUcRziSjAZzvIzuw==
X-Received: by 2002:a17:90a:1984:: with SMTP id 4mr14467276pji.207.1590846640542;
        Sat, 30 May 2020 06:50:40 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id l11sm2630172pjj.33.2020.05.30.06.50.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 06:50:40 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: fix overflowed reqs cancellation
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <955c64413e6f3883646d8fdaefbf97438f56acca.1590832472.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b4eed451-8671-6620-75e1-522785a4154b@kernel.dk>
Date:   Sat, 30 May 2020 07:50:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <955c64413e6f3883646d8fdaefbf97438f56acca.1590832472.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/30/20 5:19 AM, Pavel Begunkov wrote:
> Overflowed requests in io_uring_cancel_files() should be shed only of
> inflight and overflowed refs. All other left references are owned by
> someone else.
> 
> If refcount_sub_and_test() fails, it will go further and put put extra
> ref, don't do that. Also, don't need to do io_wq_cancel_work()
> for overflowed reqs, they will be let go shortly anyway.

Applied, thanks.

-- 
Jens Axboe

