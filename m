Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C73A21E1E1
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 23:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgGMVJl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 17:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgGMVJl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 17:09:41 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCED5C061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 14:09:39 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id l17so3552579iok.7
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 14:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=uKdBgmMUldOQardOHP/EmlF3/a90UuibASyEsYkhOqI=;
        b=KasBGjqmEGfH16t6HIeMmOpiD4cIrjt52QAREVIZSAp5eFoyx2XbHy2ZjoCBEP36yB
         XdF0iccPQWb3Xx650yno5WwOS+ZO7aY6PeNM8F93rKXlRLD/o6OzLQiNF99Z3bIyNPRU
         8T/fngbO+XSHuAY6YfOEZ9GlhywIOoENa6FQNlXtwQroctqXYUt+14RG4GtfgTCPnpJ4
         eK+tMeOxSAS+64ab+aifEAOHE56WvYAojpGlYNXWIpakQWkDPHArlchBfaAqH3KKLCsz
         2wc3JGsx2uH+ifOAwa00g1kUa4TiC/+fV0WP6BItm+q8s7fB5j9rBF8zvXbAno8W288Z
         x2zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uKdBgmMUldOQardOHP/EmlF3/a90UuibASyEsYkhOqI=;
        b=JwtYq1PtoUCyFtGh4WcB+9y3bplgH4Sq6oBq6jCDB4SeQZZdJn/UkZDIbADKtlJlxW
         4XUtbaJzJ5B8qEvIJCM8CJ98KdSA9EQykY4PnFsLGSoPV8h4rXwXU7a9cu76vlFXel5g
         Bcj2oDiEh3tfFaCRNlKVvH/cq+pk1cmmNZako3zrBPTt+KH1dVPW2jX8hdiJ0cVje/pY
         smkuNOhaIV4YBF9dsyOwafLlcKfsNHvTDjPkcRC23iZWUDFL4WfX0PoCNARvoV+WccD1
         kdtJO4b68MXLctkwDxWWDE52mWzLBM0bVJit9Wla0xLK7R3+K4CVCn9CMmtPMCHyAniO
         Lw9w==
X-Gm-Message-State: AOAM532qvIXRBs+j5Ivos7HICFolBUIGCRy00J6gNO6yJV7krwIK4SyA
        AyGjnTmanOCzveVdVHukxzASOrDg8KPR/g==
X-Google-Smtp-Source: ABdhPJyEEFeqxnwpKPODrAtzd68MvunN7sLH7FFzhZ+YLsMWrR+NPBLHofejaSG9kF6gHt0nILzcnw==
X-Received: by 2002:a02:9182:: with SMTP id p2mr2294657jag.69.1594674578992;
        Mon, 13 Jul 2020 14:09:38 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f76sm9130198ilg.62.2020.07.13.14.09.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 14:09:38 -0700 (PDT)
Subject: Re: [PATCH for-5.9 0/3] rw iovec copy cleanup
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1594669730.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <36a12c4e-0eec-43a2-0e0b-786be5043c37@kernel.dk>
Date:   Mon, 13 Jul 2020 15:09:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1594669730.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/13/20 1:59 PM, Pavel Begunkov wrote:
> Small cleanups related to preparing ->iter and ->iovec
> of ->io to async. The last patch is needed for the "completion data"
> series.

Looks good to me, applied.

-- 
Jens Axboe

