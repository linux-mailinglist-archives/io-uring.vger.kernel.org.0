Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9D41E31EF
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2020 00:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391754AbgEZWB7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 18:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390491AbgEZWB6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 18:01:58 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43801C03E96D
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 15:01:58 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id f189so22406234qkd.5
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 15:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wFyf2LBGYvGusFP43rIvmvMj6csrO70L2r6mtlSO9dc=;
        b=rYoyg9+Je2ZBkMoBWH+yfXZTkMNPG3iZ7HGEW4+JjsmhEjNiDpAe1ETwdFHs+wTTlv
         4yhWBvRVkVch6Vej6DUgMlS4Jc42HJEtgEQUjSxP9gTpcltSad7v0TEUXW13sdqFE2PJ
         KEXFT7oict3RSbVycqpeCDDhp/h0RuzDMF9/Bmo9CeoypDDxe6T3c/OMAYLoNQm9lJPA
         AnSJKjEMcLEQAXln/0ZWFX+/zbrpqpHb2PaqRGpRXME10WwcP6cdnVtE/J3zJH+hFXZU
         eb8NHqLdWN174rh02bYHFO16mvHbBjThrty93MBSnpbbcsI/o+CNCLTH3SYehDygMlov
         Xo+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wFyf2LBGYvGusFP43rIvmvMj6csrO70L2r6mtlSO9dc=;
        b=oTfuWTkJrm/u8/fA6k7+TFX9F1VnYqcD0J89TQ7UT6lnyTKK63Mh01po0uhzPCxE8Q
         pkDKGaJiH7xRXWn1k4Bvciz6nlc3cJ75ukthgNA3mbnLFX7gy7uhlw3IP8XgXJjyx3uI
         brBUTDMiTPT+RHkeQ7zIZeLS3F/CxQaW/Nh+KNzyFYne4nerj7qzqVYESOH9l0Sgfbw2
         8/GpNOaqO8nCRXGeO209AWoGPGdnn6+QqAFbJATEJDlZnf0R9WJxie4QieanSqobuLSs
         ZtODGAXUr7jMzU1PXK3YlQGpcSIeww43V5w4+fVU9aRs/3gZTOYuOn+NfUgMO57oNP9k
         EIqg==
X-Gm-Message-State: AOAM533GiqBkExPT1qkbrUSNvFaoM+YsAkOpwIFtewU+15v7U4WZ1nMR
        KPCxWbfOBdPjVseXqo71PmVMfw==
X-Google-Smtp-Source: ABdhPJzYfNSECc3ExsPyOFv3thSrOj31TioNh+sxpB0emnK2SYr5mr5i6LVkpZtDvB3rkXw+/mjL8g==
X-Received: by 2002:a37:e101:: with SMTP id c1mr942846qkm.433.1590530517442;
        Tue, 26 May 2020 15:01:57 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:2921])
        by smtp.gmail.com with ESMTPSA id n68sm700264qkb.58.2020.05.26.15.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 15:01:56 -0700 (PDT)
Date:   Tue, 26 May 2020 18:01:33 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 11/12] mm: add kiocb_wait_page_queue_init() helper
Message-ID: <20200526220133.GE6781@cmpxchg.org>
References: <20200526195123.29053-1-axboe@kernel.dk>
 <20200526195123.29053-12-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526195123.29053-12-axboe@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 26, 2020 at 01:51:22PM -0600, Jens Axboe wrote:
> Checks if the file supports it, and initializes the values that we need.
> Caller passes in 'data' pointer, if any, and the callback function to
> be used.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
