Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25DDF642CFA
	for <lists+io-uring@lfdr.de>; Mon,  5 Dec 2022 17:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbiLEQgH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Dec 2022 11:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiLEQfn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Dec 2022 11:35:43 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5E420362
        for <io-uring@vger.kernel.org>; Mon,  5 Dec 2022 08:34:32 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id vp12so29174622ejc.8
        for <io-uring@vger.kernel.org>; Mon, 05 Dec 2022 08:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O4WPtqOs6pYDke8VCfpzwsIX+8zN33o8tLS2XMy/lFU=;
        b=M4hL4Dkh0GS+ejIid/YSsq8jpzXdTpGAgUJKycJ35EFDygxWeaszkk7Z6rnTlj8Hn+
         NuQvQcVQMOFEzRX19K5Y1qo9cY3xjKlONbvZNOcKp/98mrRm1CKGttwKzdqvvqPMOe4A
         3mlI3wUilgBVy+Wqly7/hLRvzYcWi4MStMmcJnc62nvI81vAge4l628SQCDQWwMJ/LLZ
         DtfBlL8NRNKRbfKvxz7qa+Qu1CFcWsvJrR6ppkf9ONYkGljYFc9SqXm3F4bNc22qctAr
         5d6UxG1WJ04P0X0t/6skAgZ1hjriOEdGIMRXyQGrfp+8Nfdhf3OouuOm9tmj93CJYtCE
         Yzwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O4WPtqOs6pYDke8VCfpzwsIX+8zN33o8tLS2XMy/lFU=;
        b=1lHCQfaLWt2RciMAdryxrxmRvgtJa9VcjuECeNs6g4y3z8f/CIU6AcdLxr1yuvBbCK
         OhRPtVoVeuvyhR/fL5G6YwJK/R0Gzn8ZVgfVPSaX4Kxiiy0HHcRp5gqDLjWHpQh0OeuH
         jZPSBenGUcNn/5zjWrLv3pgBOtPMAoQ9Ir77fjbqrFieLyQ3Fltu0g8Guo6ZnIyvQTAw
         pl45JxisIvkQ1UbtTqmyfNkiV5IEb5wDDle+JXz4QOR6tSf1/r4GeLdFHBkg8p7NoEF1
         3RZccpGApRJh5AeGn7jmWrS1xzxRGxX2+zNBWki/7hAVfdfNORZBoOVTJLdByCPJa87T
         xypA==
X-Gm-Message-State: ANoB5pl5fWRd5ND6ka9iEcb4ggvI+efdAWzycVmIBLUs4CRsMBFjQoBr
        rvIogyMJzHVElUrUoY5QaQewMPoY9hpt/m/2FrE=
X-Google-Smtp-Source: AA0mqf4Fgg09FLsqqE3BrNtfLt56BRMkjH137pnBFQmTk19/gBlz8mHCBmdhXz0809KBf4m8ZHJEYSuDE16GSJgzhaI=
X-Received: by 2002:a17:906:2404:b0:7ad:d411:30af with SMTP id
 z4-20020a170906240400b007add41130afmr27376154eja.636.1670258070902; Mon, 05
 Dec 2022 08:34:30 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6f02:3b6:b0:27:90e6:e1d1 with HTTP; Mon, 5 Dec 2022
 08:34:30 -0800 (PST)
Reply-To: plml47@hotmail.com
From:   Philip Manul <alomassou1972@gmail.com>
Date:   Mon, 5 Dec 2022 08:34:30 -0800
Message-ID: <CA+_U6tjoYsXiWpQTRE+oV+pARumxEg919oTO_B7BXFDqCyL2TA@mail.gmail.com>
Subject: REP:
To:     in <in@proposal.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--=20
Guten tag,
Mein Name ist Philip Manul. Ich bin von Beruf Rechtsanwalt. Ich habe
einen verstorbenen Kunden, der zuf=C3=A4llig denselben Namen mit Ihnen
teilt. Ich habe alle Papierdokumente in meinem Besitz. Ihr Verwandter,
mein verstorbener Kunde, hat hier in meinem Land einen nicht
beanspruchten Fonds zur=C3=BCckgelassen. Ich warte auf Ihre Antwort zum
Verfahren.
Philip Manul.
