Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33825BBDE8
	for <lists+io-uring@lfdr.de>; Sun, 18 Sep 2022 15:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiIRNDf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 18 Sep 2022 09:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIRNDe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 18 Sep 2022 09:03:34 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DE21C106
        for <io-uring@vger.kernel.org>; Sun, 18 Sep 2022 06:03:33 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id d8so17888472iof.11
        for <io-uring@vger.kernel.org>; Sun, 18 Sep 2022 06:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=pLTFL7hTckaNfgHIHV57XSskaRQPcAggnsEzKarBNz8=;
        b=2HXgv4Mp9vN+p8FhvDOeLyanuHXyHKNI1dzay4MaDkeJff9TsmIq7vba1vrRAKaPG1
         RaECd6bizqwWldWEP4dQBC/ViwufYx2qRyZt/ca2oVGcavMUFNZUt3pj6TOgCZasRj0q
         tZfQCduiIwCa2NgdmkOZPWXWbzv3uoaAIFVn81EbWtLU5DEiRcMFS5GpcjkQVHyJcRUk
         qvYWeCVzqF73KjTQFOQkIN752TMF6l5Sk3wOeWTBOOj+YyrjZahUNtvleNs84jSE8wdt
         hYHkRURuCPWddvMEnzv57LMMmtoUzzF0G34AF+f80oEx9Cg34zYaKm5xAnHiXTxDMMBE
         JJYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=pLTFL7hTckaNfgHIHV57XSskaRQPcAggnsEzKarBNz8=;
        b=COuznV+795JrZ4Z9RWb1SkdTiY+1m8UyHLLTVUnRzwLBXQrEuVIz08Gx5peGRNoHv0
         wacobzwusUw+iuXqiXQ5kszou8w6Wf4SO7YTg8JcwUoFefZRMWD4NZ6eMVDgv4u0B7sL
         1BhTy65WCS6aGwsBUXmnAVc9dQHnEkyKTu7kj6pptN35fCX/EaawiKOXenp/pMaZWmcE
         FU/ElOcqcrskGMv0NnlULuB5RqDgy5UY6652Y1gaUT29E1SeNO8lIVIEup4C5aM+koeD
         2sbpiOIHVtAzX6rj88WbhBaYSMlJYyhtvRZrEqgbv2ghA29Wkx/08yltcuNF14EZ+lP5
         agtA==
X-Gm-Message-State: ACrzQf0AIcvclAwup794WjaUXf3CrFjaR0cPON+27ZDoWnLjg0emj3gl
        bqXVHysUiHqXxl1U8lowyMHXdhC5qlrYkQ==
X-Google-Smtp-Source: AMsMyM7GDPMnfGxd3t7+8ikxznmQtcwPktCTillqMjDXHEs5HO6oj72lhGIKCpS2RYRP3unlIveOeQ==
X-Received: by 2002:a05:6638:13c1:b0:35a:54e8:a388 with SMTP id i1-20020a05663813c100b0035a54e8a388mr6296550jaj.268.1663506212957;
        Sun, 18 Sep 2022 06:03:32 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q1-20020a0566022f0100b00688e35a2674sm13222135iow.40.2022.09.18.06.03.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 06:03:32 -0700 (PDT)
Message-ID: <0640d13f-ad3f-f5ba-ebd7-3ea862836dc5@kernel.dk>
Date:   Sun, 18 Sep 2022 07:03:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Follow up io_uring pull for 6.0-rc6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Nothing really major here, but figured it'd be nicer to just get these
flushed out for -rc6 so that the 6.1 branch will have them as well.
That'll make our lives easier going forward in terms of development,
and avoid trivial conflicts in this area.

- Simple trace rename so that the returned opcode name is consistent
  with the enum definition (Stefan)

- Send zc rsrc request vs notification lifetime fix (Pavel)

Please pull!


The following changes since commit fc7222c3a9f56271fba02aabbfbae999042f1679:

  io_uring/msg_ring: check file type before putting (2022-09-15 11:44:35 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.0-2022-09-18

for you to fetch changes up to 9bd3f728223ebcfef8e9d087bdd142f0e388215d:

  io_uring/opdef: rename SENDZC_NOTIF to SEND_ZC (2022-09-18 06:59:13 -0600)

----------------------------------------------------------------
io_uring-6.0-2022-09-18

----------------------------------------------------------------
Pavel Begunkov (1):
      io_uring/net: fix zc fixed buf lifetime

Stefan Metzmacher (1):
      io_uring/opdef: rename SENDZC_NOTIF to SEND_ZC

 io_uring/net.c   | 16 ++++++++--------
 io_uring/opdef.c |  2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

-- 
Jens Axboe
