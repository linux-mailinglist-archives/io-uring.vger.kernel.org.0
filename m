Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99CAC3966A4
	for <lists+io-uring@lfdr.de>; Mon, 31 May 2021 19:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233525AbhEaRPr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 May 2021 13:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233976AbhEaRN4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 May 2021 13:13:56 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C653C0611E0
        for <io-uring@vger.kernel.org>; Mon, 31 May 2021 08:22:36 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id b145-20020a1c80970000b029019c8c824054so2070493wmd.5
        for <io-uring@vger.kernel.org>; Mon, 31 May 2021 08:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=V+ZL6IBlYhDhqaW2K8qSQL0I2+furW7I5Lbh2PK3hX0=;
        b=IYZUwmDmolDAOMuoBoJWOc2a4BMAHvvvbctjjiOCriaSu9mvbbBH7OBv9QEh3/l82P
         lQG2m6YU8eyhGioN3AYqHDRjydVbQ6A/B+IXDodTDid8psl7guO86PdjDXL+WkhqQ48j
         sOJbjaiwKylS5m2vgF0lPiL2ItJEaIGRSJMXsOwHKWfcN5D+kuuIMvDOnOCnz4h2FCX/
         mdGn6aDHTDVdEsjBMIH5snNP46MXfEhr7goVLTr5K/2BJRNocu+grI8OPMeftheWDTFO
         sCWFdSJwALRo5OKx8Zfu9DES30WthVo+2nlB4K/EONqSmagRlRYYZQG7g7WLjeV94xWD
         yh/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=V+ZL6IBlYhDhqaW2K8qSQL0I2+furW7I5Lbh2PK3hX0=;
        b=bd+TIsCod4TtYziFVRoS3nrY7liQ7wY8GEBNT7bhs6DDnQdpi7ExQW8HDp1G5rClVs
         kLiz8hnbmxFEEas05MaVOvtn5yWI7E3t5PCkrLrZX1fNJk7eYt6JLZARRUgKfQ6234Vg
         6eoRJNp+FiHHZXR5J3nEA6ATFVo4PxdpqrWiiqNNzTgC1HaQUG8mNwCaWc94tsho8xE5
         eF6rPQvitH71++r/oSUFIN5T300pyd6KhIbvo3bavZY5oXcrTIRi5hcg6VRSNq//2AHa
         Wl+u5MyNp5D/lYzyY/KDmcsLRaU/S/z354uhO4TFEYqchOmP7adzhvGRx766sO7YOIlI
         Rcnw==
X-Gm-Message-State: AOAM530wkG9tN8XVEoem+oa0YDnviJZdx9hRJKLVH5jJCx/E0Rwko+Em
        QFqwC7H9HK0NCavImlmX0LY=
X-Google-Smtp-Source: ABdhPJwOnVf9nJQOLg47C5jM5A6GSGOWt182OSq7fgfnt5PZ7E5Gx00gt99IizuT8GMUgcaZhtpIMg==
X-Received: by 2002:a7b:c084:: with SMTP id r4mr21288618wmh.102.1622474555159;
        Mon, 31 May 2021 08:22:35 -0700 (PDT)
Received: from [192.168.1.152] ([102.64.221.114])
        by smtp.gmail.com with ESMTPSA id q20sm12176wrf.45.2021.05.31.08.22.30
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Mon, 31 May 2021 08:22:34 -0700 (PDT)
Message-ID: <60b4ff3a.1c69fb81.35c46.00ed@mx.google.com>
From:   Vanina curth <sanderlow01@gmail.com>
X-Google-Original-From: Vanina curth
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Ello
To:     Recipients <Vanina@vger.kernel.org>
Date:   Mon, 31 May 2021 15:22:23 +0000
Reply-To: curtisvani9008@mail.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

How are you? I'm Vanina. I picked interest in you and I would like to know =
more about you and establish relationship with you. i will wait for your re=
sponse. thank you.
