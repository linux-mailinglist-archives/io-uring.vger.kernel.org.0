Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704F15708BF
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 19:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiGKRSs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 13:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGKRSr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 13:18:47 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56219A445
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 10:18:45 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id y3so5548319iof.4
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 10:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0tFRdeac06SJMsCOq/f2cgz2EY5sDCDg1mZk+43QRV0=;
        b=ka65AOIn5LxDbde2si8bwDbYBSN5qbpoeB2GLKlYUZKseQ/isw0mnUoMaMQUQa7JWz
         eQ8LecRXq7XZ+7i8GGZOOW3pdQ31Jh2bO47iYCh85DaiZeXFik9p0R8CheRULUcbX49x
         L6alNSRp/Hg56lhOQQK7CACBpdtw+TKsSaBEvWiVe4SJv8y7jILgKd78IRjzsjEqbnAB
         BzOLdUib9++niIUMMWWMMdSkeq2OlvNYWcPo3Mdrf4aefcSiWhNA9K9UkKICcpPYVMLJ
         Nr8H+/bNrI2wLcvqVpm551r3J8B5TZMnfW94RMEXkWMP32wjl/ABNhyQ/lMCuq2hh5LR
         lMog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0tFRdeac06SJMsCOq/f2cgz2EY5sDCDg1mZk+43QRV0=;
        b=Zlk0CujnjexOFU6zv2X37/0rMaVMOXyXcLDzssNkmbac3riRK76B3EFgz6GN4bGvzC
         8qY1hvSq75Hrgq0VXguoKi6OCot0gRqac4JVJx2jCqP70tyzXFrOCERBV/6Gltr/rkKi
         6H7lvpVD4m6yI7iirV++xRaCPyHIKAGxO49dFM8fY0E3Ws/gwV2qSluj+KnBDP8WmNx7
         AolRQxItt9Gv1pcE/M+RaGFXQiXgZhvQMPJQFPxz6krOkgdnRD6XYkfgwuTIf1B3nBxs
         GrCCDS4lsGLgy+3nIv6rB3+T+WSYlQuGTyuS3degR6L/ACOXRcgBQZHyx75dJiQAvk/e
         k7jg==
X-Gm-Message-State: AJIora8LsZr7ASoFcEZyX3hf85JZgQpFs3MGUpVCHH/1/av1u7i8PQ55
        heJz8IyQTl/guMSmUvTTvRflxg==
X-Google-Smtp-Source: AGRyM1tZ/tuzzEuYjxyhBIk6pqAW/CgmVerMDOF3aoAdK7DDenHSvDRfSrbmPmIdIqisEtD/k7IrLg==
X-Received: by 2002:a05:6638:328d:b0:33d:5615:a95a with SMTP id f13-20020a056638328d00b0033d5615a95amr11039045jav.96.1657559924743;
        Mon, 11 Jul 2022 10:18:44 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q17-20020a920511000000b002dc2a5abf44sm2856494ile.62.2022.07.11.10.18.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 10:18:44 -0700 (PDT)
Message-ID: <2b644543-9a54-c6c4-fd94-f2a64d0701fa@kernel.dk>
Date:   Mon, 11 Jul 2022 11:18:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 3/4] io_uring: grow a field in struct
 io_uring_cmd
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de, sagi@grimberg.me,
        kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <20220711110155.649153-1-joshi.k@samsung.com>
 <CGME20220711110824epcas5p22c8e945cb8c3c3ac46c8c2b5ab55db9b@epcas5p2.samsung.com>
 <20220711110155.649153-4-joshi.k@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220711110155.649153-4-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/11/22 5:01 AM, Kanchan Joshi wrote:
> Use the leftover space to carve 'next' field that enables linking of
> io_uring_cmd structs. Also introduce a list head and few helpers.
> 
> This is in preparation to support nvme-mulitpath, allowing multiple
> uring passthrough commands to be queued.

It's not clear to me why we need linking at that level?

-- 
Jens Axboe

