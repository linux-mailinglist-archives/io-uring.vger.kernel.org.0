Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49FE66E94F4
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 14:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbjDTMqc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Apr 2023 08:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbjDTMqb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Apr 2023 08:46:31 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7185E61AB;
        Thu, 20 Apr 2023 05:46:19 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B599B68AFE; Thu, 20 Apr 2023 14:46:15 +0200 (CEST)
Date:   Thu, 20 Apr 2023 14:46:15 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Breno Leitao <leitao@debian.org>
Cc:     Christoph Hellwig <hch@lst.de>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        axboe@kernel.dk, leit@fb.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, sagi@grimberg.me, kbusch@kernel.org,
        ming.lei@redhat.com
Subject: Re: [PATCH 1/2] io_uring: Pass whole sqe to commands
Message-ID: <20230420124615.GA733@lst.de>
References: <20230419102930.2979231-1-leitao@debian.org> <20230419102930.2979231-2-leitao@debian.org> <20230420045712.GA4239@lst.de> <ZEEwHk32Y8IcT20n@gmail.com> <20230420123139.GA32030@lst.de> <ZEEyKolzQgfkEOwv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEEyKolzQgfkEOwv@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 20, 2023 at 05:38:02AM -0700, Breno Leitao wrote:
> Since we are not coping the payload anymore, this is not necessary. Now
> we are copying 64 bytes for the single SQE or 128 bytes for double SQE.
> 
> Do you prefer I create a helper that returns the SQE size, instead of
> doing the left shift?

I think a helper would be nice.  And adding another sizeof(sqe) seems
more self documenting then the shift, but if you really prefer the
shift at least write a good comment explaining it.
