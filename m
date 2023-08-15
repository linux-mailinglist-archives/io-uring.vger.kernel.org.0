Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4ADF77CE9F
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 17:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237555AbjHOPAe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 11:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237850AbjHOPA2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 11:00:28 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D2D98
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 08:00:27 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1bba9539a23so9669035ad.1
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 08:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692111626; x=1692716426;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xvqxlqxzsVAJ46UIRkOeQ1JiGfSUv1oeEKgluy2xoMM=;
        b=IjwLxs1i2cRXFErJCc3RVVRoQhhpeM+vTnR3TVX0SPIqpZ96YFqSFVeO0u+ReI97xN
         HwQyEOI+rEvFGWFpDurMX4cudGmheQmaUlsW5njwqByLnOa+oLxfr8yLgdAMY78VN4iF
         Lhw7Qd+mGTmcca73r06X58eSZxIM2RwHDDfjCgtL0ZEiBrILcsw7mPpUCvDPwuuIQePJ
         cAC+I1QGh3IC/kCtbzsnfewZnONR0qRT1qolthuQUJ5VEMaEeS5ptUJaqldkphXu9CTC
         cO9WnRAMNC2zBkKXDAvgeTcc10j7zKRnU6VZQVfibMyxoqYZmd4U+HJxgLKJOtUKhfCL
         0U3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692111626; x=1692716426;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xvqxlqxzsVAJ46UIRkOeQ1JiGfSUv1oeEKgluy2xoMM=;
        b=AV9IiMKCYUnOdvB3exXmM0BHliP69Q+Axweb+LBmsOBndaadmUjOttcDIX3oH4Ivoa
         hUPnf8lkzSeYzvdieo/5kHaGXIibcOiOHa7u/kYzvSPTDwWd1pTqmcyqBSEM1Jpb+R4K
         QYbXBeJGkl7jA3tCFA3pXkMZGg/5RgIA2nLvVQE7+bMY2oWaOCruNPdc9m6a02zDlXT8
         vIJzUekkgdaQ+p3eUUgRKW/LauCAiAYsApkMSPdGAaAGvGCgqX1opDAZmfHxiFimEDGM
         5XgMkOwFDbq0RLhLUYz6ch7RVHeRDnF6qwlTY+g0zIOR8tMpHtfKSC7qlGNKC+Lp2UWu
         g9yg==
X-Gm-Message-State: AOJu0YxiOh2Y+sJ5AqI2LPMxi/r6ju8km37mnKMpN/CkyAc1jc0IeBLP
        Vg7rJVjOlXiHQpPJJ82iQ6lIIY71ev0vFzhwZPw=
X-Google-Smtp-Source: AGHT+IHTcfCAouoFt9jaHxx++mKI4f8nYXgerY0VSo0LZQWeVWuAeFftHJLdexQX+pBgCDDk6N0j7A==
X-Received: by 2002:a17:902:cec1:b0:1b8:9fc4:2733 with SMTP id d1-20020a170902cec100b001b89fc42733mr15493619plg.3.1692111626540;
        Tue, 15 Aug 2023 08:00:26 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t12-20020a1709028c8c00b001b8b4730355sm11167033plo.287.2023.08.15.08.00.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 08:00:25 -0700 (PDT)
Message-ID: <c7b0f98c-d4c9-42a6-8671-43947bd7a63b@kernel.dk>
Date:   Tue, 15 Aug 2023 09:00:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] io_uring: Stop calling free_compound_page()
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     io-uring@vger.kernel.org, linux-mm@kvack.org
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-2-willy@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230815032645.1393700-2-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/14/23 9:26 PM, Matthew Wilcox (Oracle) wrote:
> folio_put() is the standard way to write this, and it's not
> appreciably slower.  This is an enabling patch for removing
> free_compound_page() entirely.

Looks fine to me, nice cleanup too. Please use 72-74 char line breaks
though in the commit message, this looks like ~60? With that fixed:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

