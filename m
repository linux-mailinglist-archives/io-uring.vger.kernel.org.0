Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B0C1DB78E
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 16:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgETO6D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 May 2020 10:58:03 -0400
Received: from sonic311-13.consmr.mail.bf2.yahoo.com ([74.6.131.123]:44267
        "EHLO sonic311-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726439AbgETO6D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 May 2020 10:58:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1589986681; bh=lMwnL/6WltFrTd0TmVnY+7WY/Sq+3khHK9hYAyAunB4=; h=Date:From:Reply-To:Subject:References:From:Subject; b=NvraLUKjJTFO6EkCnJEAK4TrRA/gyYcly16LoLn6EpnJV0PuDLpq4+BLD7RZUNoI4j/vAv9bcA7hNZdcI7WH7DNl2CU92wh0HBXpioqYow969tiR/gHTypfmSuBFSPM0XXm91kE5ab7URJh3rKyXPpbIJNbTAdU9W4yxm6h4552b79nI5FL8TtMcK8cZ8q2Iu1maooByva/3jFcGsluaCFg6WKu0ivHtyR7BwdfE90uhzMv06BNoP3Ia8va1adta/qJ1r3JMUaCJslqkjRMrQPg8LMrh+6VFPqidLBMpSnjIahRilkss0yY7qQ7uTE/PQENaDd1OjLgTfZrCvy8kMQ==
X-YMail-OSG: qyK_cPcVM1kKP_5G35pYBaUecwcHyxO3bsA7NwFHKclve4siQvvCAjAajlK3Sk4
 fWQuDuCombti9fGnLP1wjShdjN5oh4j4TfyqxpvklO8l4gi4npGVmcFHTRrC9VXDgwmngv27ZVbc
 QY2VaS8PWp8n4Hykb1kS6kxq7mZ9OH98asowSlD.59YHVxHHr9KGN111tg3ftYDnZ9ReQpI7pMMD
 XdjmF_xgPsPiZsfWiT1x6zYi55ByjUzH.xjZ49gO9iLoXZd.bJ44NAn8U1x7zRGQCXCcllS7hdNo
 qUYk6XVj.w4Z5nvHiOGNADjPqFQF.HTbvp7KHtCfvwZzIUTiBTa0o0M_IrT6NyUG4QhVagVVVDx.
 NMU8HGBdslOYwpr2b2h4ePiSys4EGqhspKnC_zLVUm5smWpnB1kPooHne6v_aR5gdytq7aK27mQt
 WaPRnSlnnncF3aCOm1aBW69bZ6rjQkIafOJ6t.5JRXlI2auSHMWGuglbLeSNLoCLgSaseuqa15n6
 OgOSJ9ikT8tGRuIMKP.Pzg_vKvH3kgE0t06BoFgBxhV4waDuvOYBCiVsB4bQ_XvAg6Ey.jHo0272
 5wWgpi0OS5WaZJw9wWStCXpn64kwhS1155ffJEsTFRGes8lTFHR0eyCpZ2r5H7IdJMn4pp6weGJk
 P.qJVKUaA2UuoAc__VZQB_8zf9Ka2tgRfkknIFfqfwJnNSpJoXg6lmh2uEDD1qtvsNgV2A11yEGi
 FtOk9LuHqi0KEaxPqxAy7ZF0m6..WewqH1uM4r8_Ciyb3SfdfIjI45j1pFuCOiqlJIEueGYgAYeK
 nx7ae.9zcT94NbqEwiSgDbnBNtjmFUihaIOSMxqb0tLs8zffr94TqTfxq_FvLBrltQovBVM12GA9
 BufwsDvySvvt_.fxM.d6_aPjkpUUe3fGpdy8mj7XckPO4vHop5t48MbNfsVrNU9sdT1MvhKjZkHA
 KbN3Ebb6DI64ZE.O.wb5Z60P1xLJYD7HHCd9uO770GAr458mVNzzqhfXf43d13XYJNkVBynb78se
 pxhBKa.fZFW.ojS6wSRPb3dJmkNHpmOQWwG8oleCqGvv593QK4OM07J1yf0T4dC2co17BDFrAwfM
 UaezlfhoS9iKupl5_vMXsjjaxtQZX2XOMxCZeX.qj6RtLW_MpzzjZFhk9v62S9MeMlP0wIgMOhdE
 UcsLzADLYToIgk5pM6G4pvvaTsKCk4rdHtfcG085sZZ17uop9QBYS6pTKLhotiZ.oEc90lvz7z9D
 vjU7Rvh4UR.g7muuzvPvfMbY5S7p3cgd5YJ5zwKdhci7MHJVmQAwB.i3DFZBJnl6_zAToWQOGpQ-
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.bf2.yahoo.com with HTTP; Wed, 20 May 2020 14:58:01 +0000
Date:   Wed, 20 May 2020 14:57:56 +0000 (UTC)
From:   Rose Gordon <rosegordonor@gmail.com>
Reply-To: rosegordonor@gmail.com
Message-ID: <37153645.1457746.1589986676658@mail.yahoo.com>
Subject: Greetings to you
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <37153645.1457746.1589986676658.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15960 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:72.0) Gecko/20100101 Firefox/72.0
To:     unlisted-recipients:; (no To-header on input)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Greetings to you,
I hope that this letter finds you in the best of health and spirit. My name is Rose Gordan, Please I kindly request for your attention, I have a very important business to discuss with you privately and in a much matured manner but i will give the details upon receipt of your response,

Thank you in advance!

Yours sincerely,
Rose.
