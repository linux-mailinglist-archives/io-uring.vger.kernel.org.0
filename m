Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF43C6D50F1
	for <lists+io-uring@lfdr.de>; Mon,  3 Apr 2023 20:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbjDCSrZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Apr 2023 14:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbjDCSrY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Apr 2023 14:47:24 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36DE30FD
        for <io-uring@vger.kernel.org>; Mon,  3 Apr 2023 11:47:11 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id n19so17686650wms.0
        for <io-uring@vger.kernel.org>; Mon, 03 Apr 2023 11:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680547630;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=thpW2yIVRuQD3Ko7WI8K4xaeuPEUYZxxJQxPTk5qMCw=;
        b=c0vFvv39Wzv3bP0xl/fi7BRGDEykEL/AwaeipvhHCMkTv1IA9Bppb1bXtv14fJTIuW
         zHcJjSl11a+5GUd/QkLQkdVlJb988OQkX2ilYef7COs1/TfRK/sDTyZZ+pqb/QaWQqdd
         pfes9EBx58gOlu8Tg42/rPnrKjxozx42Tw+FRueyQ0ociCmM9+PwcmMAvVxAZBLNsZQI
         Rp9r9Ku555yHXOMs2wdklCfcoQfqkHsQ4grRyybe4IrsjowEbI8ah5ziZmcSnvXanoaK
         CtrvgJ/wb+TuSIR8YbHCIfRyI5+8L1toBFrii8ddcPSWozTx7KkxgUxVSjAGqIrsIHww
         Wf9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680547630;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=thpW2yIVRuQD3Ko7WI8K4xaeuPEUYZxxJQxPTk5qMCw=;
        b=txOF7jPzTZomLnN0Hrui/J2p1KWFC6RSWZ4TbHOe+k73pNr5w0Oyal2yoW0ykcK2Bq
         mSU9G7syJS8NumGfTPno4UUD0KE+SPZ7lfRadjuaMKDjBXQmLKpRtTI9eLJd1nGsCgvW
         jARdsu74sNnpEcMwGxQz/JxJ/Q++MkKlyTq+teVzHyBrS9OGdAzg7Sjt+812IZwjwa3s
         Nh4BJ/uDXYuexAPl1qIiRowS/eN/aNzMpEMn7iAeWJqH0J0lQN1EfMbyPdvaxoTHLJ6I
         j2XjOf2yUevxMQppOp/K8UssZW09CmFsarn8RL5r4tE6N8vbMgGnnd6wtHpWJxA+9Jlo
         JzeQ==
X-Gm-Message-State: AAQBX9fkM9nbK/1c/NBBdad9I4+RuMOSGqlAXkky3p2K24NVRkhCf/wr
        0EE9Vl14A8zBoHyzdOvYg14L0TwrfncO9axcaYs=
X-Google-Smtp-Source: AKy350aunabGiyGxbBDjc80cG0Ycdi5DnYLj/cPZfCDrk4inLNysecwdobNMJzYFROGpTdIBTMUI1VE7Eoqi/CbliMU=
X-Received: by 2002:a05:600c:2312:b0:3e1:787:d706 with SMTP id
 18-20020a05600c231200b003e10787d706mr112048wmo.2.1680547630163; Mon, 03 Apr
 2023 11:47:10 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:dbd0:0:b0:2bf:f516:b18f with HTTP; Mon, 3 Apr 2023
 11:47:09 -0700 (PDT)
Reply-To: jennifertrujillo735@gmail.com
From:   jennifer trujillo <jennifertrujillo0004@gmail.com>
Date:   Mon, 3 Apr 2023 19:47:09 +0100
Message-ID: <CA+YNgfWF+eqn4OhjY_hjhHYybF22f1COoFp=z6L7F9KFZx=NJQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

-- 
Hello,
How are you?
