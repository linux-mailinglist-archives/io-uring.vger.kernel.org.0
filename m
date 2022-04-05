Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB864F22CF
	for <lists+io-uring@lfdr.de>; Tue,  5 Apr 2022 08:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiDEGCc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Apr 2022 02:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiDEGCb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Apr 2022 02:02:31 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3D969CC1
        for <io-uring@vger.kernel.org>; Mon,  4 Apr 2022 23:00:31 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B9FB668BFE; Tue,  5 Apr 2022 08:00:24 +0200 (CEST)
Date:   Tue, 5 Apr 2022 08:00:23 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Pankaj Raghav <pankydev8@gmail.com>,
        Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [RFC 3/5] io_uring: add infra and support for
 IORING_OP_URING_CMD
Message-ID: <20220405060023.GD23698@lst.de>
References: <20220401110310.611869-1-joshi.k@samsung.com> <CGME20220401110834epcas5p4d1e5e8d1beb1a6205d670bbcb932bf77@epcas5p4.samsung.com> <20220401110310.611869-4-joshi.k@samsung.com> <20220404071656.GC444@lst.de> <CA+1E3r+nHBace_K1Zt-FrOgGF5d0=TDoNtU65bFuWX8R7p8+DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3r+nHBace_K1Zt-FrOgGF5d0=TDoNtU65bFuWX8R7p8+DQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 04, 2022 at 08:44:20PM +0530, Kanchan Joshi wrote:
> Another stuff that got left out from the previous series :-(
> Using this field for a bit of sanity checking at the moment. Like this in nvme:
> 
> + if (ioucmd->cmd_len != sizeof(struct nvme_passthru_cmd64))
> + return -EINVAL;
> + cptr = (struct nvme_passthru_cmd64 *)ioucmd->cmd;

Do we actually need that sanity checking?  Each command should have
a known length bound by the SQE size, right?
