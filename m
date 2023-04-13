Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C11B6E0BE4
	for <lists+io-uring@lfdr.de>; Thu, 13 Apr 2023 12:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjDMK4o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Apr 2023 06:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjDMK4n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Apr 2023 06:56:43 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1841730
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 03:56:42 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id ly9so13234049qvb.5
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 03:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681383402; x=1683975402;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YgsQjPYSA4x9EUAST26pLIMgzwk5/fmUNEDBBVE+P4A=;
        b=otgyPboMq8mFvcDWKPydNF+pMqrQBiNKG9vAuo1BgvubjWTwJwxWsaEcLxd2cshybO
         h1D9dKIuW+Zw1tvjJu7k1IVqNKyLkAIcmf9Fl78Usvy48Qwx0wm2hcnod235hFjzsQha
         xs010QoT975By0orIVNWVCPPq8qxsHGVjyqhz75B8/X/8ukxM8ZJQSDxNu0AMELOlpqF
         AsEZydxCiClQIaOAqT96K7sV7dks5Bht+CIunmsyKzZaoDop2id8TuAH/NHnd4g5SQNQ
         J4E/J1A7O3O4aWfdPjEroh+PiJXiWsIDn++sYZgkw4R6XAbyFYSG/RvfvJClIB5nG+KL
         9SAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681383402; x=1683975402;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YgsQjPYSA4x9EUAST26pLIMgzwk5/fmUNEDBBVE+P4A=;
        b=Mgwe/DmelNJjqtWhx24gZKzrbiGna7u95Edtq9k69FtNqdMon6XNGIGYEPA+3KgJnE
         v0bklpAb1e540sKS5oTjYh701gBsGS55QJbl8D8IOgor2FJ7Y7YfSXCCinoHYCpg007C
         PGDrjbDMQ7bo9UjfLV8vjI1fdJdm473RCi2dnRqMWk9cwsDdPTIZRaFXqxi3ZrTbsUtr
         BFC7yE9K9L2+MTuSshqKWXTwFn68DllJN3v0nbj46niIqkfUYq2Eu/q/DcSxPtn2xU65
         25gmOPZRvNyLC1oKiuqdMTLaCVRFgl2SVfGo3RALkZMP8VWSvUqUKF0xoPgEeuTpOQ88
         q5ig==
X-Gm-Message-State: AAQBX9cm/2gP132uUQUftkN31/SfflJ7BV1O5Cq/T7deNAdbvY3eE14T
        +B6b3UnMejmj/upPIMXpN6qD+ndqq7jBRUQQitA=
X-Google-Smtp-Source: AKy350ZaEXxAwUvxRh1Up0yCLBX2A8H3PYy6cILL1HU0ISIYiOR7vhjxfwibCiDxIB6JOwSMsfBl9+JORQrrKx67jT8=
X-Received: by 2002:ad4:4f91:0:b0:5ef:181e:2e53 with SMTP id
 em17-20020ad44f91000000b005ef181e2e53mr377910qvb.10.1681383401692; Thu, 13
 Apr 2023 03:56:41 -0700 (PDT)
MIME-Version: 1.0
Sender: hbruunmrsanna@gmail.com
Received: by 2002:a0c:dd06:0:b0:5ef:44a4:999e with HTTP; Thu, 13 Apr 2023
 03:56:40 -0700 (PDT)
From:   Dr Lisa Williams <lw4666555@gmail.com>
Date:   Thu, 13 Apr 2023 03:56:40 -0700
X-Google-Sender-Auth: AsjGu-i7TXiUQRz_3sTMDr54yT0
Message-ID: <CAFVNgy3sqtdG42sb=TB6BNTRG=XgTp7txjsdnuk5n_ur-utYXw@mail.gmail.com>
Subject: Hi,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

My name is Dr. Lisa Williams, from the United States, currently living
in the United Kingdom.

I hope you consider my friend request. I will share some of my photos
and more details about me when I get your reply.

With love
Lisa
