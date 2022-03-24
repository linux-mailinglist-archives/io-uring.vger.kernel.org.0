Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C374B4E5E99
	for <lists+io-uring@lfdr.de>; Thu, 24 Mar 2022 07:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbiCXGW3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Mar 2022 02:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbiCXGW3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Mar 2022 02:22:29 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F138E388B;
        Wed, 23 Mar 2022 23:20:57 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id E22FC68C4E; Thu, 24 Mar 2022 07:20:53 +0100 (CET)
Date:   Thu, 24 Mar 2022 07:20:53 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshiiitr@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 05/17] nvme: wire-up support for async-passthru on
 char-device.
Message-ID: <20220324062053.GA12519@lst.de>
References: <20220308152105.309618-6-joshi.k@samsung.com> <7a123895-1102-4b36-2d6e-1e00e978d03d@grimberg.me> <CA+1E3rK8wnABptQLQrEo8XRdsbua9t_88e3ZP-Ass3CnxHv+oA@mail.gmail.com> <8f45a761-5ecb-5911-1064-9625a285c93d@grimberg.me> <20220316092153.GA4885@test-zns> <11f9e933-cfc8-2e3b-c815-c49a4b7db4ec@grimberg.me> <CA+1E3r+_DEw5ABPbLzSp9Gvg6L8XU-2HBoLK7kuXucLjr=+Ezw@mail.gmail.com> <3ed01280-5487-7206-a326-0cd110118b65@grimberg.me> <666deb0e-fa10-8a39-c1aa-cf3908b3795c@kernel.dk> <28b53100-9930-92d4-ba3b-f9c5e8773808@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28b53100-9930-92d4-ba3b-f9c5e8773808@grimberg.me>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 16, 2022 at 04:50:53PM +0200, Sagi Grimberg wrote:
>>> I know, and that was my original question, no one cares that this
>>> interface completely lacks this capability? Maybe it is fine, but
>>> it is not a trivial assumption given that this is designed to be more
>>> than an interface to send admin/vs commands to the controller...
>>
>> Most people don't really care about or use multipath, so it's not a
>> primary goal.
>
> This statement is generally correct. However what application would be 
> interested in speaking raw nvme to a device and gaining performance that
> is even higher than the block layer (which is great to begin with)?

If passthrough is faster than the block I/O path we're doing someting
wrong.  At best it should be the same performance.

That being said multipathing is an integral part of the nvme driver
architecture, and the /dev/ngX devices.  If we want to support uring
async commands on /dev/ngX it will have to support multipath.
