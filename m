Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D49D171B0A
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2020 14:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbgB0N67 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Feb 2020 08:58:59 -0500
Received: from sym2.noone.org ([178.63.92.236]:53752 "EHLO sym2.noone.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732251AbgB0N67 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 27 Feb 2020 08:58:59 -0500
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 48SvR51Kplzvjc1; Thu, 27 Feb 2020 14:58:57 +0100 (CET)
Date:   Thu, 27 Feb 2020 14:58:57 +0100
From:   Tobias Klauser <tklauser@distanz.ch>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: use correct CONFIG_PROC_FS define
Message-ID: <20200227135856.g4acgcphhbnlxt5y@distanz.ch>
References: <20200227130856.15148-1-tklauser@distanz.ch>
 <27593a49-d50a-6296-a4b7-f35ba09014fb@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27593a49-d50a-6296-a4b7-f35ba09014fb@kernel.dk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020-02-27 at 14:56:45 +0100, Jens Axboe <axboe@kernel.dk> wrote:
> On 2/27/20 6:08 AM, Tobias Klauser wrote:
> > Commit 6f283fe2b1ed ("io_uring: define and set show_fdinfo only if
> > procfs is enabled") used CONFIG_PROCFS by mistake. Correct it.
> 
> Oops - I folded this into the original.

Great, thanks. And sorry for not checking more carefully before sending
the patch.
