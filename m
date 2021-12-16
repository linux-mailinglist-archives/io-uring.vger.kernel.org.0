Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6E8476CEA
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 10:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbhLPJKW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 04:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbhLPJKW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 04:10:22 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B10C061574;
        Thu, 16 Dec 2021 01:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=SDbNwlnmUfWQEEZ7mNqfqtat5p
        857hOz0u81R4UCT1c9c6AmoarRCuqUKXu17g+hzg43Q047X5Xsk28zCNXsMuPhEJve/v+hUosvcal
        QDDjN1nnUJRgx1uQaKIou3glG+VNNJ/+S9FwEwR4NkO0sEq7PqcoR2QkNfOzo92qgdTVx6h21IPjV
        ZdtJ0Hbr2MJAfvhAvDYbeSCsxMYaJv9T/MipTsoI2MphD3G5TcGz8OSZ/MKQ3jJxWYqsbzgMfuVi4
        kDBzOy+5G6elcgxyJowigat2buuBB09DRzdfbAuhEyggvrfAS5WNj4RCDFSx94y4ynBkRvfrcCsDB
        3E9/QxZw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxmmL-004KK9-ES; Thu, 16 Dec 2021 09:10:21 +0000
Date:   Thu, 16 Dec 2021 01:10:21 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 1/3] block: add completion handler for fast path
Message-ID: <YbsCfZOTsfxCdusa@infradead.org>
References: <20211215163009.15269-1-axboe@kernel.dk>
 <20211215163009.15269-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215163009.15269-2-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
