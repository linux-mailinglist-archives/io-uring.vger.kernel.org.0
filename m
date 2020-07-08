Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77F92193A7
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 00:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgGHWkk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 18:40:40 -0400
Received: from casper.infradead.org ([90.155.50.34]:45958 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgGHWkj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 18:40:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UNmO82B1L6vK/6Ekgs8DFfG07q3A5V9knSP06sf1Q/Y=; b=FWHWswvitMxH1eY7zuhuceHQZq
        +Abxb2tnwfDZjH8VHbqMU1EYBiLIqBMGixGi1Yuy8/HkOwOvfhaIniw6VPQXjSo7698mZkAW7hAsV
        NL/iPMIvgni9YGO6C6n0afY2vSF0PW+eNR6Mh/QWwZJndpNBUMAEdy9G6H4KQzMqoBWRxKC8481Se
        WLERSQNZf9bUkUT8YiMjiEM9yII18sZLBBC97ehQ2EetwbGvqEiFSWanHIbHdW7XytZtHxbY1V4Pt
        OVx1BrEuOVhcrDbX9Uzj434S/rMrF4LX5QDsKr3MnvPdNF+P8G6adklo342HXGkaRla2y9exzvNRh
        nO9/1qvQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtIjy-0006ef-Qq; Wed, 08 Jul 2020 22:40:35 +0000
Date:   Wed, 8 Jul 2020 23:40:34 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH 1/2] fs: Abstract calling the kiocb completion function
Message-ID: <20200708224034.GX25523@casper.infradead.org>
References: <20200708222637.23046-1-willy@infradead.org>
 <20200708222637.23046-2-willy@infradead.org>
 <983baa4b-55c6-0988-9e43-6860937957b4@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <983baa4b-55c6-0988-9e43-6860937957b4@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 08, 2020 at 04:37:21PM -0600, Jens Axboe wrote:
> On 7/8/20 4:26 PM, Matthew Wilcox (Oracle) wrote:
> > diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> > index b1cd3535c525..590dbbcd0e9f 100644
> > --- a/crypto/af_alg.c
> > +++ b/crypto/af_alg.c
> > @@ -1045,7 +1045,7 @@ void af_alg_async_cb(struct crypto_async_request *_req, int err)
> >  	af_alg_free_resources(areq);
> >  	sock_put(sk);
> >  
> > -	iocb->ki_complete(iocb, err ? err : (int)resultlen, 0);
> > +	complete_kiocb(iocb, err ? err : (int)resultlen, 0);
> 
> I'd prefer having it called kiocb_complete(), seems more in line with
> what you'd expect in terms of naming for an exported interface.

Happy to make that change.  It seemed like you preferred the opposite
way round with is_sync_kiocb() and init_sync_kiocb() already existing.

Should I switch register_kiocb_completion and unregister_kiocb_completion
to kiocb_completion_register or kiocb_register_completion?
