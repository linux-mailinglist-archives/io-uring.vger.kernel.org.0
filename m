Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF5A4E4ABE
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 03:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240974AbiCWCL5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 22:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbiCWCL4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 22:11:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39E145AA66
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 19:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648001427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+VhNzK/4rqz9BBZ+NUufmtY5hd4LqSi4mcImA5YtOoE=;
        b=SIs4b2gJhk7NzfItrC80ETjFGzNzUmzgIbCeNO3T41YuE+Q/YnG+ZnUZFRsv+QgPobdC2i
        WBH3TR5Jmz0JqtsdN2W9dyvFtvDl7q9CjF9sUHpRoPhwLnyr/sa7yd9cPlGWYQMVPJC7D/
        us8VKD1ArluzppHWGfkP9qYbKl6rA9o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-W-2kOXqDMXG8RgqKftdt1g-1; Tue, 22 Mar 2022 22:10:22 -0400
X-MC-Unique: W-2kOXqDMXG8RgqKftdt1g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C58C1C05ABA;
        Wed, 23 Mar 2022 02:10:21 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E729DC202C5;
        Wed, 23 Mar 2022 02:10:11 +0000 (UTC)
Date:   Wed, 23 Mar 2022 10:10:06 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        Kanchan Joshi <joshiiitr@gmail.com>,
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
Subject: Re: [PATCH 10/17] block: wire-up support for plugging
Message-ID: <YjqBfpLVhJ3nZMur@T590>
References: <20220308152105.309618-1-joshi.k@samsung.com>
 <CGME20220308152714epcas5p4c5a0d16512fd7054c9a713ee28ede492@epcas5p4.samsung.com>
 <20220308152105.309618-11-joshi.k@samsung.com>
 <20220310083400.GD26614@lst.de>
 <CA+1E3rJMSc33tkpXUdnftSuxE5yZ8kXpAi+czSNhM74gQgk_Ag@mail.gmail.com>
 <Yi9T9UBIz/Qfciok@T590>
 <20220321070208.GA5107@test-zns>
 <Yjp3dMxs764WEz6N@T590>
 <c7ce0850-0286-ec6b-2d68-20226e7bae16@kernel.dk>
 <a1693c16-151e-60f0-ed8d-25e98dce57d4@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1693c16-151e-60f0-ed8d-25e98dce57d4@kernel.dk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 22, 2022 at 07:58:25PM -0600, Jens Axboe wrote:
> On 3/22/22 7:41 PM, Jens Axboe wrote:
> > On 3/22/22 7:27 PM, Ming Lei wrote:
> >> On Mon, Mar 21, 2022 at 12:32:08PM +0530, Kanchan Joshi wrote:
> >>> On Mon, Mar 14, 2022 at 10:40:53PM +0800, Ming Lei wrote:
> >>>> On Thu, Mar 10, 2022 at 06:10:08PM +0530, Kanchan Joshi wrote:
> >>>>> On Thu, Mar 10, 2022 at 2:04 PM Christoph Hellwig <hch@lst.de> wrote:
> >>>>>>
> >>>>>> On Tue, Mar 08, 2022 at 08:50:58PM +0530, Kanchan Joshi wrote:
> >>>>>>> From: Jens Axboe <axboe@kernel.dk>
> >>>>>>>
> >>>>>>> Add support to use plugging if it is enabled, else use default path.
> >>>>>>
> >>>>>> The subject and this comment don't really explain what is done, and
> >>>>>> also don't mention at all why it is done.
> >>>>>
> >>>>> Missed out, will fix up. But plugging gave a very good hike to IOPS.
> >>>>
> >>>> But how does plugging improve IOPS here for passthrough request? Not
> >>>> see plug->nr_ios is wired to data.nr_tags in blk_mq_alloc_request(),
> >>>> which is called by nvme_submit_user_cmd().
> >>>
> >>> Yes, one tag at a time for each request, but none of the request gets
> >>> dispatched and instead added to the plug. And when io_uring ends the
> >>> plug, the whole batch gets dispatched via ->queue_rqs (otherwise it used
> >>> to be via ->queue_rq, one request at a time).
> >>>
> >>> Only .plug impact looks like this on passthru-randread:
> >>>
> >>> KIOPS(depth_batch)  1_1    8_2    64_16    128_32
> >>> Without plug        159    496     784      785
> >>> With plug           159    525     991     1044
> >>>
> >>> Hope it does clarify.
> >>
> >> OK, thanks for your confirmation, then the improvement should be from
> >> batch submission only.
> >>
> >> If cached request is enabled, I guess the number could be better.
> > 
> > Yes, my original test patch pre-dates being able to set a submit count,
> > it would definitely help improve this case too. The current win is
> > indeed just from being able to use ->queue_rqs() rather than single
> > submit.
> 
> Actually that is already there through io_uring, nothing extra is
> needed.

I meant in this patchset that plug->nr_ios isn't wired to data.nr_tags in
blk_mq_alloc_request(), which is called by pt request allocation, so
looks cached request isn't enabled for pt commands?


Thanks,
Ming

