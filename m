Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBED4542EA4
	for <lists+io-uring@lfdr.de>; Wed,  8 Jun 2022 13:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237439AbiFHLDy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jun 2022 07:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237422AbiFHLDx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jun 2022 07:03:53 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE111C207F
        for <io-uring@vger.kernel.org>; Wed,  8 Jun 2022 04:03:48 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id v9so22296325lja.12
        for <io-uring@vger.kernel.org>; Wed, 08 Jun 2022 04:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=cwHCFxNZfdLDfyPThL+uTO+4unUHZXMe5v3cBT1R5wc=;
        b=VqU7FrM7JH8u4EM/XxUeDwliGNGGDt4QBiOpK0jQ3rZBl9Ie5uaMW5vPcF4PjVNo65
         1M/lP7QZKYPzmWr/zv8K2carGjqXlYVGcph16WQyKsM9H8pElPl2SUlKCak8jr+jVZFU
         oGZkbifepgMCghQbs8hHgv37vv0X/9DO6F1DbNgW/Bjapiay22xFfD+hd2sXw/Z5Cloo
         GKrUo73+kNNXQAu95kT5/s7UoSbQjxrEGYaBKnCAk9yrY953LuUjh2ihbbCoQdBf/Lro
         C1RvaMuT9rQSkGJ4W6+Oq8KZuAznDzq/K2ezTZdw4OUdWSoDndWELeQs8ZzBLs08c/E0
         tMRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=cwHCFxNZfdLDfyPThL+uTO+4unUHZXMe5v3cBT1R5wc=;
        b=vbsuVFNIeWXvaKbZrmgLZrWH7bGoajYORBSI7wYtSS9UDCWj0lZBMQlfPTLb/j5pWl
         2u1bPHmZlP2pcm/4nh42+33j64Kg6h/3EFfFwDEIFJnXGfkXLCpm4z2coT09acP/EQ1F
         qSTfu3KxqkKpIv22aIHff8BoW4vyihlykFBfXDQZ0DAezS7iAmD84kUNyIDw3zBVSsGk
         qFw8c7oSX/6ZpDco8jPcPkwvFINETkRNV0vdRGDo0pp5GXtjL1T7LLqblyjiOir5TpTG
         NbBIEUijGF2YKtcac6GXCL0DWbuhn7xZa6B/Dba1lqGwKRLNq4Nlc6Ps8YdM17s4ZsGa
         Jx+g==
X-Gm-Message-State: AOAM531f/Y2LMNCyDSyo/PlAH0aH1jUDd55EgKjlEawDIHOS2DjPkES+
        AK7m0fmSxwoGbNHvCSR9dqBVLRT8+jIUsTpSlFY=
X-Google-Smtp-Source: ABdhPJybo0J+8SYeEoDTfBqxuNXeuRk+GVzgEyPVA6xgh8QTE040IGLWHelDMPd22FNadoLETltrek2fOUaPctxsnvg=
X-Received: by 2002:a2e:98d6:0:b0:255:6e24:7ce3 with SMTP id
 s22-20020a2e98d6000000b002556e247ce3mr19383545ljj.164.1654686226843; Wed, 08
 Jun 2022 04:03:46 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:aa6:c3a1:0:b0:1f2:b9db:65c with HTTP; Wed, 8 Jun 2022
 04:03:46 -0700 (PDT)
Reply-To: alifseibou@gmail.com
From:   MR MALICK <anubis14172@gmail.com>
Date:   Wed, 8 Jun 2022 04:03:46 -0700
Message-ID: <CAJRrMJng+=dZBKbB9P6rkEOfEnzBw2-4Gh87qTo7RJ6GjfCtTA@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=4.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

0JLQq9CY0JPQoNCr0Kgg0JIg0JvQntCi0JXQoNCV0K4uDQoNCtCS0LDRiNCwINGN0LvQtdC60YLR
gNC+0L3QvdCw0Y8g0L/QvtGH0YLQsCDQstGL0LjQs9GA0LDQu9CwIDIgNjAwIDAwMCDQvNC40LvQ
u9C40L7QvdC+0LIg0LTQvtC70LvQsNGA0L7Qsi4NCtCh0LLRj9C20LjRgtC10YHRjCDRgSDQsdCw
0YDRgNC40YHRgtC10YDQvtC8INCt0LTQstCw0YDQtNC+0Lwg0KDRjdC50LzQvtC90LTQvtC8INC/
0L4g0Y3Qu9C10LrRgtGA0L7QvdC90L7QuSDQv9C+0YfRgtC1INC30LTQtdGB0YwNCiggZWRhaGdh
dG9yQGdtYWlsLmNvbSApLCDRh9GC0L7QsdGLINC30LDQv9GA0L7RgdC40YLRjCDRgdCy0L7QuSDQ
stGL0LjQs9GA0YvRiNC90YvQuSDRhNC+0L3QtCwg0YPQutCw0LfQsNCyDQrRgdCy0L7QuCDQtNCw
0L3QvdGL0LUg0YHQu9C10LTRg9GO0YnQuNC8INC+0LHRgNCw0LfQvtC8LiDQstCw0YjQtSDQv9C+
0LvQvdC+0LUg0LjQvNGPLCDQstCw0YjQsCDRgdGC0YDQsNC90LAuINCy0LDRiA0K0LTQvtC80LDR
iNC90LjQuSDQsNC00YDQtdGBINC4INC90L7QvNC10YAg0YLQtdC70LXRhNC+0L3QsC4NCg0K0KEg
0KPQstCw0LbQtdC90LjQtdC8Li4NCtCzLdC9INCc0LDQu9C40Log0KHQsNC80LHQsC4uLi4NCg==
