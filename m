Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820446FB317
	for <lists+io-uring@lfdr.de>; Mon,  8 May 2023 16:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbjEHOkv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 May 2023 10:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234362AbjEHOku (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 May 2023 10:40:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71ECAE3;
        Mon,  8 May 2023 07:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=q4o1nD2sqnVINUa4wJkpzUBUiyouZyIVltFc/M2sha0=; b=vm83vsBtzNa3RY/548w4l3FUGB
        rT/L5W0thNhYdspynIEDnrSsvhuf/dysX/xse1VtTYmun/Rt5R4Akg8MxElRrG5/qmpo8YvWcwesC
        HVxiUeRwDGQq+9M0ll4Bf3zA36xHLfejEALlZHWdpAfRRzlFUZCHUQBZuD9FdOKZ7VSjRzdDamk0r
        6k+7u8PzIPkXkFB5IRWvLEqquairThEuOUtBYMQaCPakFRJ3Z+XS9ulHRuTn4PmBABR3pKGVPSZcT
        f7QBIh/eDvCU7MlE3HNdhLU9NnjKT57YsfDRku22M6xbFAWePIkdNp9qH2C8cCI/h+JYkin159cdF
        tGEywpAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pw22N-000mND-1Y;
        Mon, 08 May 2023 14:40:27 +0000
Date:   Mon, 8 May 2023 07:40:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        Breno Leitao <leitao@debian.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] io_uring: add dummy io_uring_sqe_cmd() helper
Message-ID: <ZFkJ2x+XCMmDzOR4@infradead.org>
References: <20230508070825.3659621-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508070825.3659621-1-arnd@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 08, 2023 at 09:08:18AM +0200, Arnd Bergmann wrote:
> Add a dummy function like the other interfaces for this configuration.

Why do we need a separate dummy? The structure is unconditionally
defined, so we can just unconditionally define the helper.
