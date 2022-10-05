Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138B05F5424
	for <lists+io-uring@lfdr.de>; Wed,  5 Oct 2022 14:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJEMDo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Oct 2022 08:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiJEMDn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Oct 2022 08:03:43 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8521B27150
        for <io-uring@vger.kernel.org>; Wed,  5 Oct 2022 05:03:42 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id s192so3146065oie.3
        for <io-uring@vger.kernel.org>; Wed, 05 Oct 2022 05:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6WHsOaVAPt108cDTbzZrG266wz4HK2yccOlUseqNdaw=;
        b=V+029tTbIJuDO1At3unTZURda16ZoesNV2knSSX2m88JZpAUUXSzvBQ0FYdhVWMVbz
         KcB1Kz2cCA+hmyBncCxP3Wqt7ZG3U6nYLrriaE4HDrJWVchLVLQFxihBgZf/5sDd740X
         tvNM/8je2ADhjlwxboBJyqovaTXfb9Y7ZiRCm5rp5keeqSlfrxT3V3nxW8LPK38a7bae
         Z/Ei51sEyWskBZtQWBJGh1xS8WtkBKjp3kr6Q4MX7k+bU+Q/HobbPEQi3XcGrM2RHyQ0
         EBZzV3Qb/MSfKWOoRBsAeYO2AkHh1nLDe3n6t+Y+X95HbD/7y4m52KJyfFtP7MlIeogc
         7uEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6WHsOaVAPt108cDTbzZrG266wz4HK2yccOlUseqNdaw=;
        b=Ghh3TGsGgD1FcAkUBykVs4oqWJCqetOxwdoIbUbGq7cWSWhf+jSiWOBlcOOLERIQet
         p+u+S8GE3epy7DQm7BdnC+Gk8XvBIdSI4itJOqKEP6JYDQq5kY3hKNKbw8ZiGShV8yR4
         vElyHqfvzxtr+GgXuvjJ8V9y4748vraK8hDAgTBEmSZGVFcc0OsC4G7R0lsSZBe6g4af
         YRIzoqeSSt5hbwHlN7ndxS0lmW9D/jbFr54KGpxM6jMB2GSLHCc1puqMgcH+a7wiQLKT
         3vXczAj2NBe4Xj9HGDfVYtyHS0Jwq5odyosPDCIrpByB/y6Z8QsAx5jIWGYE8PdQeUgs
         VjQA==
X-Gm-Message-State: ACrzQf1ruK4Co6HzP+LHrmQkjuWtiAbaH135+QiTWsbT1TBTzocvvGFG
        CbtQ6+QsEBLlrFMkWSTbd/Vml/KIHLeEY0ARlvw=
X-Google-Smtp-Source: AMsMyM59axR0gXML8OvDXA07t9oWnq41TOSmEWYn+hM6yu2ArYsb3sM/cT3DNhrZGuJ+24xyHo8T91trffMeGA267fs=
X-Received: by 2002:aca:b28a:0:b0:350:79af:eab8 with SMTP id
 b132-20020acab28a000000b0035079afeab8mr2002035oif.225.1664971421559; Wed, 05
 Oct 2022 05:03:41 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:7d38:0:0:0:0 with HTTP; Wed, 5 Oct 2022 05:03:41
 -0700 (PDT)
Reply-To: proctorjulius@yahoo.com
From:   Julius Proctor <kalei7542@gmail.com>
Date:   Wed, 5 Oct 2022 13:03:41 +0100
Message-ID: <CAJ_0WQTxkEzz4N+Xsx1EcZcpFFwR7F96x8P245UJwh7xDthc+Q@mail.gmail.com>
Subject: =?UTF-8?B?UsOhZCBzaSBwb3NsZWNobnUgdsOhxaEgbsOhem9y?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

RG9icsO9IGRlbg0KDQpKc2VtIEp1bGl1cyBQcm9jdG9yLCBwcsOhdm7DrSB6w6FzdHVwY2UgeiBh
ZHZva8OhdG7DrSBrYW5jZWzDocWZZSBQcm9jdG9yLg0KS29udGFrdG92YWwganNlbSB2w6FzIG9o
bGVkbsSbIHBvesWvc3RhbG9zdGkgZm9uZHUgemVzbnVsw6lobyBEci4gRWR3aW5hDQp2ZSB2w73F
oWkgOCw1IG1pbGlvbnUgZG9sYXLFrywga3RlcsOpIG1hasOtIGLDvXQgcmVwYXRyaW92w6FueSBu
YSB2w6HFoSDDusSNZXQuDQpOYXbDrWMgdiB0w6l0byB0cmFuc2FrY2kgY2hjaSwgYWJ5c3RlIG9k
cG92xJtkxJtsaSBkxa92xJtybsSbLg0KDQpKdWxpdXMgUHJvY3Rvcg0K
