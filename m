Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E1A47B3A6
	for <lists+io-uring@lfdr.de>; Mon, 20 Dec 2021 20:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240791AbhLTTYC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Dec 2021 14:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240790AbhLTTX7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Dec 2021 14:23:59 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C7DC061574
        for <io-uring@vger.kernel.org>; Mon, 20 Dec 2021 11:23:59 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so588597wme.4
        for <io-uring@vger.kernel.org>; Mon, 20 Dec 2021 11:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=VFAYdUcoAa/RBUsWThLomBm2E0VJ5Yt60qDK5YTAZfk=;
        b=TLmkIG0woTdlQqXCe4v5m72M3U2o1gGHV2dnw8veAzpnrXuylLvXqQn1UaA0aRYPoD
         z9+pMWGOZx/zwJalL+i6ZNlCbzFeGhsbvcdQVSD+5Pyp5EfpxWqLgAuxs59GuDWCfqLS
         hgbiAjH/aduU13Osw/T6nssKDClkhOAz0GG+8ND6yE6GDhQO/+87cuZXq2St108qC1Gv
         kCcZChyjUlguCm4wYSXu5QqU1TxLF8WvbuFs2WWgBL20psnr2LvXIsas4hL2kK/kldpg
         FW8OENE4xjzj6/I6NWBF3Zb8CJsOGNAafLqJN3JX3b+0EsJMlcBC9StE7jtDHRdEIa8Z
         KklA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=VFAYdUcoAa/RBUsWThLomBm2E0VJ5Yt60qDK5YTAZfk=;
        b=pbLkrUBrHFZfkfqBUE65qi9BKz9J9LE9sFqKQH3P6Ra57fuXp0dStFgJAxMcry5Q4o
         d9ZKP3UlwQXPlFE9mQ23+McDzIxlJ2K2kjtvf0bjZkUD6uzP+e+MieMak3YVdi6oDqcW
         bS4YCjaUcaQdjfUVVqm52ad79u869xpjW0ldMK6AdbdXmj8eBpTqvjtDJq6KoSHHi/2E
         TNTuJBB5G2F25ivKMdozb0zMkM8jO+SdaToQ59CPVDI7SYZUzVzSBmKwCq5o0l79rTWt
         2puGIyHGg/eWoyYO2Lkfnl0pdk/FpHF1izBIMVvKegJfn1lT9YpKb2N27qkYJIk3Pd7X
         lbcg==
X-Gm-Message-State: AOAM533DpOxYYI/a+ehdROLvqepi6pQLve8mLDpc6dVlcEWSd9HAoKuV
        4pCPAOOL0Co9zT206rbKE0k=
X-Google-Smtp-Source: ABdhPJwYvo3FmLm6rSdiQFt4hzQTvi9fVm3ys2tSWvpGLDP/ogqUu7F2+p/+CkTsWgoNcQvLwlTyHw==
X-Received: by 2002:a1c:a517:: with SMTP id o23mr353760wme.189.1640028238088;
        Mon, 20 Dec 2021 11:23:58 -0800 (PST)
Received: from [192.168.1.80] ([102.64.218.242])
        by smtp.gmail.com with ESMTPSA id k6sm200496wmj.16.2021.12.20.11.23.52
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Mon, 20 Dec 2021 11:23:57 -0800 (PST)
Message-ID: <61c0d84d.1c69fb81.7c165.14c9@mx.google.com>
From:   Rebecca Lawrence <dodjiagon4@gmail.com>
X-Google-Original-From: Rebecca Lawrence
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Hello
To:     Recipients <Rebecca@vger.kernel.org>
Date:   Mon, 20 Dec 2021 19:23:28 +0000
Reply-To: ribeccalawrence@gmail.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Dear,
My name is Rebecca, I am a United States and a military woman who has never=
 married with no kids yet. I came across your profile, and I personally too=
k interest in being your friend. For confidential matters, please contact m=
e back through my private email ribeccalawrence@gmail.com to enable me to s=
end you my pictures and give you more details about me. I Hope to hear from=
 you soon.
Regards
Rebecca.
