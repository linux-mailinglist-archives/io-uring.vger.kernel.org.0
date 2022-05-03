Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD6B518F7C
	for <lists+io-uring@lfdr.de>; Tue,  3 May 2022 22:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbiECVAJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 May 2022 17:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbiECVAI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 May 2022 17:00:08 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83401EC7B
        for <io-uring@vger.kernel.org>; Tue,  3 May 2022 13:56:34 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 65DE968B05; Tue,  3 May 2022 22:56:31 +0200 (CEST)
Date:   Tue, 3 May 2022 22:56:31 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Pankaj Raghav <p.raghav@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v3 5/5] nvme: add vectored-io support for uring-cmd
Message-ID: <20220503205631.GD9567@lst.de>
References: <20220503184831.78705-1-p.raghav@samsung.com> <CGME20220503184916eucas1p266cbb3ffc1622b292bf59b5eccec9933@eucas1p2.samsung.com> <20220503184831.78705-6-p.raghav@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503184831.78705-6-p.raghav@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> +	union {
> +		__u32	data_len; /* for non-vectored io */
> +		__u32	vec_cnt; /* for vectored io */
> +	};

Nothing ever uses vec_cnt, so I don't think there is any point in adding
this union.

The rest looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
