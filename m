Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3B96EC4A7
	for <lists+io-uring@lfdr.de>; Mon, 24 Apr 2023 07:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjDXFJA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Apr 2023 01:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjDXFI7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Apr 2023 01:08:59 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6A6210C;
        Sun, 23 Apr 2023 22:08:47 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D845F67373; Mon, 24 Apr 2023 07:08:43 +0200 (CEST)
Date:   Mon, 24 Apr 2023 07:08:43 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Breno Leitao <leitao@debian.org>
Cc:     Christoph Hellwig <hch@lst.de>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        axboe@kernel.dk, leit@fb.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, sagi@grimberg.me, kbusch@kernel.org,
        ming.lei@redhat.com
Subject: Re: [PATCH 1/2] io_uring: Pass whole sqe to commands
Message-ID: <20230424050843.GA9252@lst.de>
References: <20230419102930.2979231-1-leitao@debian.org> <20230419102930.2979231-2-leitao@debian.org> <20230420045712.GA4239@lst.de> <ZEKno++WWPauufw0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZEKno++WWPauufw0@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 21, 2023 at 08:11:31AM -0700, Breno Leitao wrote:
> On Thu, Apr 20, 2023 at 06:57:12AM +0200, Christoph Hellwig wrote:
> > On Wed, Apr 19, 2023 at 03:29:29AM -0700, Breno Leitao wrote:
> > >  	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
> > > -	const struct nvme_uring_cmd *cmd = ioucmd->cmd;
> > > +	const struct nvme_uring_cmd *cmd = (struct nvme_uring_cmd *)ioucmd->sqe->cmd;
> > 
> > Please don't add the pointless cast.  And in general avoid the overly
> > long lines.
> 
> If I don't add this cast, the compiler complains with the follow error:
> 
> 	drivers/nvme/host/ioctl.c: In function ‘nvme_uring_cmd_io’:
> 	drivers/nvme/host/ioctl.c:555:37: error: initialization of ‘const struct nvme_uring_cmd *’ from incompatible pointer type ‘const __u8 *’ {aka ‘const unsigned char *’} [-Werror=incompatible-pointer-types]
> 	  const struct nvme_uring_cmd *cmd = ioucmd->sqe->cmd;

Oh.  I think then we need a helper to get the private data from
the io_uring_cmd as an interface that requires casts in all callers
is one asking for bugs.
