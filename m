Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F24552064
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 17:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243038AbiFTPPk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jun 2022 11:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244794AbiFTPOj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jun 2022 11:14:39 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451F926117
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 08:03:39 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id f16so9089317pjj.1
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 08:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=j1xJJmIcXhdN6E7NJSdJUfD6fFJFgdZPPBIJ2vNsan0=;
        b=ZxAxJj+CTqNDdssCmBLdZ+SROFpNJcoasz2gUQ9m0usxc2MxmvFOLLXz4md8S1S2nM
         7hIVZmttgVn+VjEib5C1qHhZc+oTQzu8YQJr71/ZN1o+KZilfTNLNtG2nfNZnlzDsU2m
         NiV3lvj7aprKpSBZSVO3LJTuqdxdWEpCAe6rF1s/XH+8MgQN0XZ8D4mrP8hmJgpU6zx9
         OUIGP3ty3SKV64CxO7MWmeUYGQPEYKd8IVrTmNW40Kn29PRt42SBxDn2NUgZ9mUpViZE
         nxvEDSOfxRkOPN1hStNIbYx4U2dv6u58XtfDyAzBwg/Fn/skK7Si4MrCKD9ZKH6sm2iw
         cBLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=j1xJJmIcXhdN6E7NJSdJUfD6fFJFgdZPPBIJ2vNsan0=;
        b=ZPz7/spO8vqC0urZ8B6++WUtdmPH15HPuVEyeeGfNQd6nYDXANdcswN/2TDL3eO+8R
         DLlWjdyFkz+zPSxkTMOe8vSY+KHRdfiRWkUE8unMrxdSGnzkzF6Ix4yHL/ZbsyQMFOdI
         qTC4KhwyCS7TRzTMd/66m4uXq/tSEmTEy/XWtzlOaIkjQHv+F9MLCvawE/D62wokXSWt
         52ctvwSK/FDzFMj0hzS3rJBXXloPPWhrv0aZs5cc+WdpiBL4qNqfwIg836huCF4rPp7l
         o+p5s9F3zpss0pL2e+iSLSkSZnW/L/V9tq/kPEYpPFUfuv/PsEOI8VrbVe6ypMvANYND
         7ZHA==
X-Gm-Message-State: AJIora/oZZHd2zawWJ6OEr5U+7ovUprrRm48dOt8f3GpXBrYJBVGj42X
        Dt3d2AvaaFmOKOEZUjZU1Hq7lP9YLF7ZXg==
X-Google-Smtp-Source: AGRyM1upENlFemUxkzCO2ONXkxO4wYyQSs7FFAkU94Yru/s1UPNt45sDHS93Tz12tM0KVRNMf9Ytqw==
X-Received: by 2002:a17:90b:1d09:b0:1ec:bb51:9396 with SMTP id on9-20020a17090b1d0900b001ecbb519396mr1928498pjb.192.1655737418664;
        Mon, 20 Jun 2022 08:03:38 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x16-20020a17090a165000b001e667f932cdsm10555026pje.53.2022.06.20.08.03.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jun 2022 08:03:38 -0700 (PDT)
Message-ID: <50304d0b-9167-7911-2960-1facd473991a@kernel.dk>
Date:   Mon, 20 Jun 2022 09:03:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 1/1] io_uring: optinise io_uring_task layout
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <282e7d40f93dc928e67c3447a92719b38de8a361.1655735235.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <282e7d40f93dc928e67c3447a92719b38de8a361.1655735235.git.asml.silence@gmail.com>
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

On 6/20/22 8:27 AM, Pavel Begunkov wrote:
> task_work bits of io_uring_task are split into two cache lines causing
> extra cache bouncing, place them into a separate cache line. Also move
> the most used submission path fields closer together, so there are hot.

Thanks, applied. The current layout is really stupid...

-- 
Jens Axboe

