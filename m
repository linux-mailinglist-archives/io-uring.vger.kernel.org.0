Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF3B4D5B98
	for <lists+io-uring@lfdr.de>; Fri, 11 Mar 2022 07:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346416AbiCKG2T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Mar 2022 01:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiCKG2R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Mar 2022 01:28:17 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280991A9072;
        Thu, 10 Mar 2022 22:27:15 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3664F68AFE; Fri, 11 Mar 2022 07:27:11 +0100 (CET)
Date:   Fri, 11 Mar 2022 07:27:10 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 17/17] nvme: enable non-inline passthru commands
Message-ID: <20220311062710.GA17232@lst.de>
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3@epcas5p1.samsung.com> <20220308152105.309618-18-joshi.k@samsung.com> <20220310083652.GF26614@lst.de> <CA+1E3rLaQstG8LWUyJrbK5Qz+AnNpOnAyoK-7H5foFm67BJeFA@mail.gmail.com> <20220310141945.GA890@lst.de> <CA+1E3rL3Q2noHW-cD20SZyo9EqbzjF54F6TgZoUMMuZGkhkqnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3rL3Q2noHW-cD20SZyo9EqbzjF54F6TgZoUMMuZGkhkqnw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 11, 2022 at 12:13:24AM +0530, Kanchan Joshi wrote:
> Problem is, the inline facility does not go very well with this
> particular nvme-passthru ioctl (NVME_IOCTL_IO64_CMD).

And it doesn't have to, because there is absolutely no need to reuse
the existing structures!  Quite to the contrary, trying to reuse the
structure and opcode makes things confusing as hell.

> And that's because this ioctl requires additional "__u64 result;" to
> be updated within "struct nvme_passthru_cmd64".
> To update that during completion, we need, at the least, the result
> field to be a pointer "__u64 result_ptr" inside the struct
> nvme_passthru_cmd64.
> Do you see that is possible without adding a new passthru ioctl in nvme?

We don't need a new passthrough ioctl in nvme.  We need to decouple the
uring cmd properly.  And properly in this case means not to add a
result pointer, but to drop the result from the _input_ structure
entirely, and instead optionally support a larger CQ entry that contains
it, just like the first patch does for the SQ.
