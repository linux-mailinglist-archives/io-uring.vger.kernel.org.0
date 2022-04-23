Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A0B50CCC4
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 19:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236725AbiDWRwy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Apr 2022 13:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236681AbiDWRwt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Apr 2022 13:52:49 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D7A1C82E5
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 10:49:51 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8631A68D05; Sat, 23 Apr 2022 19:49:48 +0200 (CEST)
Date:   Sat, 23 Apr 2022 19:49:48 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH] io_uring: cleanup error-handling around io_req_complete
Message-ID: <20220423174948.GB29219@lst.de>
References: <CGME20220422101608epcas5p22e9c82eb1b3beef6bf6e1c2e83b4b19b@epcas5p2.samsung.com> <20220422101048.419942-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422101048.419942-1-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 22, 2022 at 03:40:48PM +0530, Kanchan Joshi wrote:
> Move common error-handling to io_req_complete, so that various callers
> avoid repeating that. Few callers (io_tee, io_splice) require slightly
> different handling. These are changed to use __io_req_complete instead.
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
