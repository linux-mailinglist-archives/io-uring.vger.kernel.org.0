Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3A452333B
	for <lists+io-uring@lfdr.de>; Wed, 11 May 2022 14:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbiEKMie (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 May 2022 08:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242634AbiEKMi3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 May 2022 08:38:29 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DAD233A56
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 05:38:25 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o69so2107787pjo.3
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 05:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6WhEVSHsDA565Egp5d9HDhwu+cGxlIM6t99NlYBqV5g=;
        b=2Ex8SVi61fEvxrpYhj2SKTejb3qy3nZoCoxtciNK9s84k3RjlV2Wt/zRFzjqd1lxmE
         AEWcmlVvBCFSRgsPROdEMSp+qFpMmVa0qId2GcfYE2vWjow8YLmBFxs0xRTlTYgauZfZ
         078fGH4fMsG3siC4XqaV1zLxCYpeuCthjeczPsTmDmTjZWKZnZLjsge4PuElOaYxarBp
         uuVWRyCRFoKZAmJarzlVdUqVuTZKqOoD1g+XeXnpICtFFLn3y+8c1bLq0BGSOaCq/zCI
         l3Dhesp8Y6M4pa3guS9Z5kpnFdtESpMrKtfF3luAkqVsOz+FKQtu850981SZZNrt9BwG
         lufA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6WhEVSHsDA565Egp5d9HDhwu+cGxlIM6t99NlYBqV5g=;
        b=h7sgF3MMPzMAWHAAFJr7AJkRxKPzjAsfDRNlXRNx4ARXeafwei++0AKoXH+c5jD4CR
         3XvZFseyfV6haWwQBOwenApYFCHkyuL2tMjfIlYI4LRBnfkzIoBGcAioJQ6fY8kSim5+
         AIZrPtD+8W0cj7cxhq8Q1rlzScjuogjQ4IWgIzGvfdS1x26wVw5y4XoDCzgbrQlRZvmM
         PUIXvoZpSy0S7c3JHuqzcoksfkxIry/RFjvFz2MdGVmJjU2q1JzW3OHBOwYJjTHIyWD8
         pDipmGOqBdOzxN7ieF7dxxpS0rdbGqOSSwO3D5J7QoKCb6USj+Fu2PvGCSwi8BkLK7vj
         dj2w==
X-Gm-Message-State: AOAM532SF8Yj0xyfu8wBE6gX9WwIPZTkOW3mgmc/ON9WCXTOQ+eoh7gY
        qwAy5r/GAFTm9QmI2PicG9UDtg==
X-Google-Smtp-Source: ABdhPJzalOfoorcqazZGfnpCc+GXImojvyl5Tcat5bI0ddUIGLbUenIOINr15lBFpxnHXfalEAnhPA==
X-Received: by 2002:a17:90b:2243:b0:1dc:3f08:8316 with SMTP id hk3-20020a17090b224300b001dc3f088316mr5307653pjb.194.1652272704449;
        Wed, 11 May 2022 05:38:24 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c14-20020a62f84e000000b0050dc76281e8sm1637365pfm.194.2022.05.11.05.38.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 May 2022 05:38:23 -0700 (PDT)
Message-ID: <9e888eb3-3fd3-6c21-ddf5-4489fd54054e@kernel.dk>
Date:   Wed, 11 May 2022 06:38:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v5 6/6] io_uring: finish IOPOLL/ioprio prep handler
 removal
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
References: <20220511054750.20432-1-joshi.k@samsung.com>
 <CGME20220511055320epcas5p2457aaf8e7405387282f60831f5a4eca9@epcas5p2.samsung.com>
 <20220511054750.20432-7-joshi.k@samsung.com> <20220511065423.GA814@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220511065423.GA814@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/11/22 12:54 AM, Christoph Hellwig wrote:
> I think this should go first, and the uring_cmd bits need to do the
> right thing from the beginning.

It just needs folding in, I'll do that.

-- 
Jens Axboe

