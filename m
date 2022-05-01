Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBCA5164B2
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 16:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbiEAO2h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 10:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiEAO2g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 10:28:36 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC531FCE2
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 07:25:09 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id z5-20020a17090a468500b001d2bc2743c4so10975969pjf.0
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 07:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=FWzgMnjjhuCZxyPLDBZY/wj6xABgV0dD7l6DqPXLJ68=;
        b=GiZI+2mjTA9j8mZ6/IlGJmoJzRh/zxCbaotbzjYT7qm0bcp4MCHzy6IsyxCdfTxZ7b
         mLWQlCdJXYgG7vEptEl1kVYQHyL/NMXYeVGzUcAhecYGJpW6CY2yJk6xxFWdfR0rqW0c
         P5zX19Vx+PXkivgeYh4Zg5AHCG6T37QD6nIxXGyD0HyOpezpwr7jt5k9W1anO2PbwxP4
         XKzlPyy/KORPFJTN6NpmeOToe0uTaYqNY0Jo6IxIUjS+jKVPUK/cJE+7TshJuDSbpWpL
         pym0kLZEpx2VWeHqxkdfTanb2EQNuaW6u+xnOcsVy3s9x076PBtT/QlK/hQdvuUf3f5w
         RU1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FWzgMnjjhuCZxyPLDBZY/wj6xABgV0dD7l6DqPXLJ68=;
        b=Yx5iOtMq5h6wZ8p10n4HjJKVyxiMXy5gNkcpdZf+CZuKWOOEwnofxfPtPOZDWkd5S8
         BkTQn70Ef5VMgUPtcQS+YOUTDb4ZK0WwjtY/IvKscEQvFY2GCpZjV0etydy4gmx3UJ+j
         J9ZEgeveMXf/qUA4YCc09j3gWKRZpHbCZgm381/NBspmBHgUx3CDDPu112H2ExBJ3ds7
         LjgF1Uk+ajkYOAE+fNZDO5PInszQdIHAHITcPDQke3gFU7/lHoZq6+cAQhHcPqY8IFWt
         2RQFIlsjVXEpMM1dBKd4QOY64IPiQQKxiIYjwQswyDytfZN1xPwqSBAhoTZnRkFILtVj
         e6hA==
X-Gm-Message-State: AOAM5330H/H7blP12RfgqjpqkOKx0z4wYYyrssqHMSogiSLQnmYF9pCO
        UDsnDJkYAwpp8aNH5YeQ2tWTyXnxrYwSZeEp
X-Google-Smtp-Source: ABdhPJyTZcgbKF+xzrsNTAWJMUynmu6NlCBsfjAIbBJU9SDMxTMQRgKzhEWK++kQ7RerNXDcHWRyXA==
X-Received: by 2002:a17:90a:ce13:b0:1d9:acbe:7ede with SMTP id f19-20020a17090ace1300b001d9acbe7edemr13589707pju.16.1651415108875;
        Sun, 01 May 2022 07:25:08 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p11-20020a1709028a8b00b0015e8d4eb297sm2958043plo.225.2022.05.01.07.25.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 May 2022 07:25:08 -0700 (PDT)
Message-ID: <f7e7a485-7bc3-bf7c-3c05-73e356608913@kernel.dk>
Date:   Sun, 1 May 2022 08:25:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCHSET v2 RFC 0/11] Add support for ring mapped provided
 buffers
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20220429175635.230192-1-axboe@kernel.dk>
 <69fc3830-8b2e-7b40-ad68-394c7c9fbf60@gmail.com>
 <f7e46c2f-5f38-5d9a-9e29-d04363961a97@kernel.dk>
 <170e4200-fb7b-9496-4fcf-48d64212702e@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <170e4200-fb7b-9496-4fcf-48d64212702e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/1/22 7:39 AM, Pavel Begunkov wrote:
> I'd suggest for mapped pbuffers to have an old plain array with
> sequential indexing, just how we do it for fixed buffers. Do normal
> and mapped pbuffers share something that would prevent it?

Ah yes, we could do that. Registering it returns the group ID instead of
providing it up front.

-- 
Jens Axboe

