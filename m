Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F70B24584E
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 17:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbgHPPSG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Aug 2020 11:18:06 -0400
Received: from mail.cmpwn.com ([45.56.77.53]:58010 "EHLO mail.cmpwn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726407AbgHPPSG (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 16 Aug 2020 11:18:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=cmpwn.com; s=cmpwn;
        t=1597591085; bh=sWYtya6qO9qNy867lNy+O5W1U1djzz5KkG6dr+9QhOg=;
        h=Subject:From:To:Date:In-Reply-To;
        b=ytQHKh/Hk3h/d6NLLhaydKHYVycA/6pNdM569pHV5yz5wPnuUZFyL1u9P3exkxCyr
         dWZ8TiygcEoHb3YTKKtOQcarNvCQs5cJ/pk7EEcIk4P4P4TtAYMp9bmdeOmOYb2ykU
         1/WMc59mV3GCMEvCB4njVsVAprtYr8AeijHgeCbU=
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Subject: Re: Consistently reproducible deadlock with simple io_uring program
From:   "Drew DeVault" <sir@cmpwn.com>
To:     "Jens Axboe" <axboe@kernel.dk>, <io-uring@vger.kernel.org>
Date:   Sun, 16 Aug 2020 11:17:51 -0400
Message-Id: <C4YIRQ82YXVG.19H8P61BYECTV@homura>
In-Reply-To: <839f2d17-0486-b12d-3540-4a8408902492@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat Aug 15, 2020 at 10:37 PM EDT, Jens Axboe wrote:
> https://git.kernel.dk/cgit/linux-block/commit/?h=3Dio_uring-5.9&id=3Dd4e7=
cd36a90e38e0276d6ce0c20f5ccef17ec38c

Confirmed that this fixes my issue. Thanks a lot for the rapid
assistance!
