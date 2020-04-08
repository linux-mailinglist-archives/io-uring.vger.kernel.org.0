Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21EBF1A194E
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 02:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgDHAkf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 20:40:35 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:8917 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgDHAke (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 20:40:34 -0400
X-Originating-IP: 50.39.163.217
Received: from localhost (50-39-163-217.bvtn.or.frontiernet.net [50.39.163.217])
        (Authenticated sender: josh@joshtriplett.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 3CF76240005;
        Wed,  8 Apr 2020 00:40:31 +0000 (UTC)
Date:   Tue, 7 Apr 2020 17:40:29 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH v3 0/3] Support userspace-selected fds
Message-ID: <20200408004029.GB894167@localhost>
References: <cover.1585978979.git.josh@joshtriplett.org>
 <a2392e6e-d96d-0a6c-0f1d-95152544cb07@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2392e6e-d96d-0a6c-0f1d-95152544cb07@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 07, 2020 at 03:11:50PM -0700, Jens Axboe wrote:
> This looks pretty clean and flexible to me, and it'll work fine for
> io_uring.
> 
> Care to post this a bit wider (and CC Al)?

Will do.
