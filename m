Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCF82EE9A4
	for <lists+io-uring@lfdr.de>; Fri,  8 Jan 2021 00:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbhAGXON (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jan 2021 18:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727738AbhAGXOM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jan 2021 18:14:12 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69FDC0612F5
        for <io-uring@vger.kernel.org>; Thu,  7 Jan 2021 15:13:31 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id p18so6345044pgm.11
        for <io-uring@vger.kernel.org>; Thu, 07 Jan 2021 15:13:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=hof4tpd1PcvLRkodBFY1nC8+/qbCcpckF5BKTr98mcg=;
        b=Lt9GLzIQbOEV2JPivm5aYFbt/TVhOmJ1qsZL0tCBOLijBtUq9mkKsgXZ6NsSTSlIcM
         iPts2U1gWyHY9DCnsuluxdS/g2jmiVMSxbOB9Npd/pDCL2A+0w9vEluLIvtTZ+SPOczH
         GIJsqmByKwerd/bD+vi3mvEpiCKXXJQyKps/nGv+TAJceGjAW1wDsbE7T92Z5eDk7psK
         jj4h2IG/vphmu50WQlhXb3gd/Xfdt+U2P2oFE3dzhLLqsj/FSdD4iB920M409ypPnIAY
         2EtZZwyxmlmiiNN0DCx5D822RURJxLPrP408Cd9GMEN+ZdCFA5kXOGUEVPhtGmfGemn0
         UGtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hof4tpd1PcvLRkodBFY1nC8+/qbCcpckF5BKTr98mcg=;
        b=Oi6zw/W0pl25BHB6Wj69WEaBRllgid5PJkKgvfSz27m/QgzYg7akMDyFatq7uDWe8f
         FJ1BTX2m0s4/Yv3uTEyCu0Ia5Hf71zf0M1lhCPEW4sAHXM+1rzHuDcvE8WRTRGvdtIh5
         X/u7AaQe4DHofiAbSmbJXywtIHOdzrL4xa6EDF3kIKSs1b214ay17+/rUJTN8h5PwUvM
         Fl3FMkO2WHThA7erbLhIx+iq1oUvD+6v0e6R+pjbI+6yJKmLGwbz4cRcZ0VOTL4CwtTx
         rgerOxiVFViAAeNlBXw9xWJjmhReJF4EDxwWDNkcnbJSDyPsWM376hwJwPK/RQbG8DV3
         KrqA==
X-Gm-Message-State: AOAM531xhBJW1lxCKNQlaVDE23IjBhflEZmdVtdukwPDdsRFQcdAKL1r
        2ygGn1nWYZpvxT5PqtHKQ6x7F4rF2Vr6LA==
X-Google-Smtp-Source: ABdhPJzsyc9TxzzzOJ7OIYHGhIQySmohI6l+1R4ZhSPp6KJCOjAyRWCe4xpk5iaecRmX1EzHzt9zkA==
X-Received: by 2002:a63:da4e:: with SMTP id l14mr4179409pgj.248.1610061211028;
        Thu, 07 Jan 2021 15:13:31 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id l8sm5706967pjt.32.2021.01.07.15.13.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 15:13:30 -0800 (PST)
Subject: Re: [PATCH liburing] src/queue: refactor io_uring_get_sqe()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <0d1447abc76a1664f663f019497dbcd8b92116e3.1610060400.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <88cb3edc-8501-b16f-bc1e-c6664461be0e@kernel.dk>
Date:   Thu, 7 Jan 2021 16:13:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0d1447abc76a1664f663f019497dbcd8b92116e3.1610060400.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/7/21 4:00 PM, Pavel Begunkov wrote:
> Inline __io_uring_get_sqe() and clean up ugly naming left from it being
> a macro at some point.

Looks good, thanks.

-- 
Jens Axboe

