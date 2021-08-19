Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA193F22A0
	for <lists+io-uring@lfdr.de>; Fri, 20 Aug 2021 00:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhHSWBd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 18:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbhHSWBc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Aug 2021 18:01:32 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1EEC061575
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 15:00:55 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id a15so9669320iot.2
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 15:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SQo1wXnkLDWWUWbQQC/fmTTQJqPFB+qA/13Y1NnTOgQ=;
        b=BtzPYn0zKd+3qobRMsc0WoGqAtuOcsiey7nmOnlZucIIO/AYEEuYUhCIXMnUY33jJ4
         KJmWoD8iOIHt/9NeKMcPrMYO3dgwJf9dbaRzYuikdStYm8Dur2P08+QUYmgRm5doKYwx
         Bt18r0MwV96HMkifN5xok1tDRF5hy7oDjcPLcVvk31Fk58otUuXbqN562yi1OfAeQDni
         bbz8Y62SfDxe1bJqJ9d62OrkUKdAAXFXcOcW06fLvTxA2H5MziP5QAHvMDB+v7PrfdMZ
         vtv/ysBlkRStqY87UzbdHJvaELA9nqoRBrARxdI46bwvRZE5R7A3J+NdSMZu/+ZjYhPA
         eqNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SQo1wXnkLDWWUWbQQC/fmTTQJqPFB+qA/13Y1NnTOgQ=;
        b=ckrcGnTJR34G9/dhCFkQEbkykcgyOvTSkgxbqaFMRgkUXGpdJ1lxckx9bYXbVa/7Cw
         Mst7liFOxCOWKP3lY3qXK3EO/h8sKeailjicA91jni2pRkHzzjsQo4pD3nHof+hmpizo
         4zNQOIFwF04ew2tz3QH3zGq3QtyU9t8EpVR9nKut/4AHKusuvP5GMHNWMyYMlCN7Piwy
         N/S1fZ4WkMohvK2EitJUOrhHj9j7QdKaDI+cI9VCq5HRE42mKQ6KNmR0sE+4zIBcWBCZ
         CCkTRt4WzdAo6OQqXZ04h7+UaOSd/bC3fhKU4CApVpnuf3RnHFjjsYeR2oLWdzE7nYO6
         DBbA==
X-Gm-Message-State: AOAM531eA+kfE0dn2TCktodr81Ko0R4poFZoVBQ0cIh1RK5fp5ACBbj2
        yHNK9x1Tv9RuOEkL4WDJ1TPPQ86The7Sc7gX
X-Google-Smtp-Source: ABdhPJyP5BFmknlVRDimVNmvI08KXFQQjBXO/w8y0wICM6XQxEGxZgzgZ2n0fEpxdys5Xrq3Bz2Y5g==
X-Received: by 2002:a02:5107:: with SMTP id s7mr14920430jaa.65.1629410455110;
        Thu, 19 Aug 2021 15:00:55 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id u14sm2446030iol.24.2021.08.19.15.00.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 15:00:54 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH for-next] io_uring: extend task put optimisations
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <824a7cbd745ddeee4a0f3ff85c558a24fd005872.1629302453.git.asml.silence@gmail.com>
Message-ID: <f92723d1-a6a3-93e0-26f1-027819a1030a@kernel.dk>
Date:   Thu, 19 Aug 2021 16:00:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <824a7cbd745ddeee4a0f3ff85c558a24fd005872.1629302453.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/18/21 10:01 AM, Pavel Begunkov wrote:
> Now with IRQ completions done via IRQ, almost all requests freeing
> are done from the context of submitter task, so it makes sense to
> extend task_put optimisation from io_req_free_batch_finish() to cover
> all the cases including task_work by moving it into io_put_task().

Applied, thanks.

-- 
Jens Axboe

