Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F364715169E
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2020 08:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgBDHv0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Feb 2020 02:51:26 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51972 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgBDHv0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Feb 2020 02:51:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=yUiImlhwcIpiW7cZCXnZDPMFY1pVbnQvFpHqcngYJpA=; b=gstJsAL8wCfEyAUHmus+6yyWTS
        FTJf8/HqAHwAoYF3+90KrznEc26VGSwMoQjghTds08H67I2DqucLSFAGKoRURFqhgAbPoJlMyPFpy
        TAQ2aL1XrcAx00X1sLx+A0G7bBQkRNfDr+NcL9HP7IbFWHUbsIKl82akG0UGwyLdlKbUmTPXpISm4
        jkEePYDhBrk2NXbJaXa2+5lOYwB+FfFUziY5EQWBTs7wzZXAerzVhQ8mzqjzeF7+Y1JTuKdmXBvdy
        WcgvXnEKK/ZNE5PP7qzo8kgpvk1i4cMNGhd1G9DuTqkKGCKAsd0vvPpDuLWCDgT7nlVeqxSwIN2At
        dpNbF2iw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iyszU-0000Wx-HQ; Tue, 04 Feb 2020 07:51:24 +0000
Date:   Mon, 3 Feb 2020 23:51:24 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 1/1] block: Manage bio references so the bio persists
 until necessary
Message-ID: <20200204075124.GA29349@infradead.org>
References: <1580441022-59129-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1580441022-59129-2-git-send-email-bijan.mottahedeh@oracle.com>
 <20200131064230.GA28151@infradead.org>
 <9f29fbc7-baf3-00d1-a20c-d2a115439db2@oracle.com>
 <20200203083422.GA2671@infradead.org>
 <aaecd43b-dd44-f6c5-4e2d-1772cf135d2a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aaecd43b-dd44-f6c5-4e2d-1772cf135d2a@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 03, 2020 at 01:07:48PM -0800, Bijan Mottahedeh wrote:
> My concern is with the code below for the single bio async case:
> 
>                            qc = submit_bio(bio);
> 
>                            if (polled)
>                                    WRITE_ONCE(iocb->ki_cookie, qc);
> 
> The bio/dio can be freed before the the cookie is written which is what I'm
> seeing, and I thought this may lead to a scenario where that iocb request
> could be completed, freed, reallocated, and resubmitted in io_uring layer;
> i.e., I thought the cookie could be written into the wrong iocb.

I think we do have a potential use after free of the iocb here.
But taking a bio reference isn't going to help with that, as the iocb
and bio/dio life times are unrelated.

I vaguely remember having that discussion with Jens a while ago, and
tried to pass a pointer to the qc to submit_bio so that we can set
it at submission time, but he came up with a reason why that might not
be required.  I'd have to dig out all notes unless Jens remembers
better.
