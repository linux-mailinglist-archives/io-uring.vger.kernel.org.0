Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BD5476CB9
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 10:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhLPJBv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 04:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhLPJBv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 04:01:51 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC66C061574
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 01:01:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3Thh0nXZnceqNDdds5eXbcz6jycQJGEnJOLIzCBHNA4=; b=q0T8n7DfJ5n9RgJfiSNLMXrBfc
        88InHbUwpQrXaVKlCKCffi3rAHSoJdbfn7cSCa3wewWrBWsHQdW0+T2LbyfZuP8QqQirBt5Rhz65P
        wZrpCc52FEBTSOcwIBGRdKXyPtWSbzoPKv02zr2iZwLbmU7S4dRhWKu28BGiqrnPBj2w/XxDJOq4g
        RlTXQelZKkEezLOMr4/JL9oC986D00M2BmiznQMcT/OovJ4ODOkoxO0EYd7s1zI8y0HGLWJSJcstV
        r+zaT0zHKft3hXxmV2CIETGsx3Z5c7yZ+gBS7/YJOnWJWN7mCuUQlZxkI/OY4YXK760PIUH4bXrFZ
        FFGv4mHg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxme6-004G2Y-HM; Thu, 16 Dec 2021 09:01:50 +0000
Date:   Thu, 16 Dec 2021 01:01:50 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/4] nvme: split command copy into a helper
Message-ID: <YbsAfoawFEV2R0pM@infradead.org>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215162421.14896-3-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Just like the two times before: NAK.  Please remove nvme_submit_cmd and
open code it in the two callers.
