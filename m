Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE044E5EA0
	for <lists+io-uring@lfdr.de>; Thu, 24 Mar 2022 07:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241039AbiCXGYW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Mar 2022 02:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiCXGYV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Mar 2022 02:24:21 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1AF9681C;
        Wed, 23 Mar 2022 23:22:50 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id E116B68C4E; Thu, 24 Mar 2022 07:22:46 +0100 (CET)
Date:   Thu, 24 Mar 2022 07:22:46 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, kbusch@kernel.org,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        sbates@raithlin.com, logang@deltatee.com, pankydev8@gmail.com,
        javier@javigon.com, mcgrof@kernel.org, a.manzanares@samsung.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com
Subject: Re: [PATCH 05/17] nvme: wire-up support for async-passthru on
 char-device.
Message-ID: <20220324062246.GB12519@lst.de>
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152702epcas5p1eb1880e024ac8b9531c85a82f31a4e78@epcas5p1.samsung.com> <20220308152105.309618-6-joshi.k@samsung.com> <20220311070148.GA17881@lst.de> <20220314162356.GA13902@test-zns> <20220315085410.GA4132@lst.de> <20220316072727.GA2104@test-zns>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316072727.GA2104@test-zns>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 16, 2022 at 12:57:27PM +0530, Kanchan Joshi wrote:
> So what is the picture that you have in mind for struct io_uring_cmd?
> Moving meta fields out makes it look like this - 


> @@ -28,7 +28,10 @@ struct io_uring_cmd {
>        u32             cmd_op;
>        u16             cmd_len;
>        u16             unused;
> -       u8              pdu[28]; /* available inline for free use */
> +       void __user     *meta_buffer; /* nvme pt specific */
> +       u32             meta_len; /* nvme pt specific */
> +       u8              pdu[16]; /* available inline for free use */
> +
> };
> And corresponding nvme 16 byte pdu - struct nvme_uring_cmd_pdu {
> -       u32 meta_len;
>        union {
>                struct bio *bio;
>                struct request *req;
>        };
>        void *meta; /* kernel-resident buffer */
> -       void __user *meta_buffer;
> } __packed;

No, I'd also move the meta field (and call it meta_buffer) to
struct io_uring_cmd, and replace the pdu array with a simple
 
 	void *private;

> We would still need to use/export that even if we somehow manage to move
> task-work trigger from nvme-function to blk_mq_complete_request.
> io_uring's task-work infra is more baked than raw task-work infra.
> It would not be good to repeat all that code elsewhere.
> I tried raw one in the first attempt, and Jens suggested to move to baked
> one. Here is the link that gave birth to this interface -
> https://lore.kernel.org/linux-nvme/6d847f4a-65a5-bc62-1d36-52e222e3d142@kernel.dk/

Ok.  I can't say I'm a fan of where this is going.
