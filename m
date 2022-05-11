Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9A2523350
	for <lists+io-uring@lfdr.de>; Wed, 11 May 2022 14:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbiEKMpz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 May 2022 08:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235216AbiEKMpy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 May 2022 08:45:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5928426CF;
        Wed, 11 May 2022 05:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IuWS9dpIvB8V2t76o3BjxsIfNlJCTwJh4ct18MVXL7M=; b=Vs1EtqBVeV8SccoLlEuveq9n0l
        lJUnRf8Gi+QOatP+JAM+fhr+S+4QoYtxsKcnfeYDzaZz4dGyF0vQuR3FPiSYgRbbE2sO7lLfOXylP
        uGaQt1OuXUdCZL/MBCbjH66WECCzdQCN21G0PYAuJKxd8XYe6t88QBbqk34VkM7JkqDIzrGfRtq4V
        r6X72778s/pNpFI+CWfLnhF8qRUkmu5l/o1yq8OdVHIBluZYEVVb7rkvtCSBZOzglu3fSp47eMDjU
        2RZgMoKCHdhOl75uA5kKWF61oc6Vdw6JenDGY55AfunHcu3+cjUzdJp7wsNawfskVnGkX7tFQoi91
        Ph7ezhhQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nolin-006pKm-CQ; Wed, 11 May 2022 12:45:41 +0000
Date:   Wed, 11 May 2022 05:45:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "zhanghongtao (A)" <zhanghongtao22@huawei.com>
Cc:     gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        linfeilong@huawei.com, suweifeng1@huawei.com,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] drivers:uio: Fix system crashes during driver switchover
Message-ID: <Ynuv9YJPE0tO4347@infradead.org>
References: <d204cc88-887c-b203-5a5b-01c307fda4fb@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d204cc88-887c-b203-5a5b-01c307fda4fb@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I thought SPDK uses vfio?  Using uio for anything that does DMA is
completelz unsafe.
