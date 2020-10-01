Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3571280145
	for <lists+io-uring@lfdr.de>; Thu,  1 Oct 2020 16:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732104AbgJAOa2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Oct 2020 10:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732099AbgJAOa2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Oct 2020 10:30:28 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD403C0613D0
        for <io-uring@vger.kernel.org>; Thu,  1 Oct 2020 07:30:26 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id r24so662509vsp.8
        for <io-uring@vger.kernel.org>; Thu, 01 Oct 2020 07:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8GZ5n2u5V+QvfUH9DZS4oIvxHL1+NovLYLEheBS1wj8=;
        b=FFMM7pW3n5fCFerkvswxRl3dacjFb7wacb1PAWO1dSX7ejP0DaiP9HkcOaHx1RPjMJ
         Xhh+H+rIzpzu3SmCax8t9W4OaPdNRkv2+5RV2SLJflkS90aly84ORwzeOvOwUk1exd1C
         FkalDIVVUoL046MSR/0KW+SXRVUKbxNxlsx+/xgmcdSrMFXHKrUPR8i4g2oIHcpS3RzR
         Elwg2023YpN0F93kbrIrlT1q8/mRNxAP9xw4e66v3sCVb6h3ugP5mBezNr97AYEgX+j/
         APEXDAfddTnVGfjKiFJn+GPQyWW2Bxvup/ak4uuK23JjWeIceokIQWmVnO0c+DmcKl0k
         W/fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8GZ5n2u5V+QvfUH9DZS4oIvxHL1+NovLYLEheBS1wj8=;
        b=TlyUD4oqUNR5DJHpx44Eu4lH9qgF5m1MVuSWLupneadbRgd60q50LgnYWV8VxHWfDc
         gZP1LyTIm3l3l533sbWIczp6PL6Cx98K096kouRWHwA/sWjkBJgeRX3mwRTvlcFCePOD
         8LGUxp0O8EhjOAEpxjwkhc7Dlna9oAISHJfsFnvmX8fi0z5JPAGC2l6bz1LtyrJhPVfx
         C6Hw27XJMA+ja6bIShpkHi/BEKQhrRmpFbfB5KIkqdMI3IO95rc1B6eNoFPwuAkn3WdO
         /SjmVgjNctKI8sCawFTAkMuKqhlCpyGpKmDWWheOFXssq46fwGXXrEwAavV36i1y2brH
         rVqg==
X-Gm-Message-State: AOAM5309/8kimLTqwWTuGZ07j5I+qXswfcavV1uQvKuyxr0E01RkYvsE
        wEcXVk5scmrjovPFMIpo68k3rHLlH39znyVVjEM=
X-Google-Smtp-Source: ABdhPJw51cmrRYrz9U7xKNOmKluTP6BpCfZCf0W8ZheWkWS7GC0K9ym4hvffh8ekMrKRden0cBRnPw1ThZbNhfFo5bc=
X-Received: by 2002:a05:6102:4a1:: with SMTP id r1mr5196000vsa.9.1601562625771;
 Thu, 01 Oct 2020 07:30:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAD14+f3G2f4QEK+AQaEjAG4syUOK-9bDagXa8D=RxdFWdoi5fQ@mail.gmail.com>
 <20201001085900.ms5ix2zyoid7v3ra@steredhat>
In-Reply-To: <20201001085900.ms5ix2zyoid7v3ra@steredhat>
From:   Ju Hyung Park <qkrwngud825@gmail.com>
Date:   Thu, 1 Oct 2020 23:30:14 +0900
Message-ID: <CAD14+f1m8Xk-VC1nyMh-X4BfWJgObb74_nExhO0VO3ezh_G2jA@mail.gmail.com>
Subject: Re: io_uring possibly the culprit for qemu hang (linux-5.4.y)
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Stefano,

On Thu, Oct 1, 2020 at 5:59 PM Stefano Garzarella <sgarzare@redhat.com> wro=
te:
> Please, can you share the qemu command line that you are using?
> This can be useful for the analysis.

Sure.

QEMU:
/usr/bin/qemu-system-x86_64 -name guest=3Dwin10,debug-threads=3Don -S
-object secret,id=3DmasterKey0,format=3Draw,file=3D/var/lib/libvirt/qemu/do=
main-1-win10/master-key.aes
-blockdev {"driver":"file","filename":"/usr/share/OVMF/OVMF_CODE.fd","node-=
name":"libvirt-pflash0-storage","auto-read-only":true,"discard":"unmap"}
-blockdev {"node-name":"libvirt-pflash0-format","read-only":true,"driver":"=
raw","file":"libvirt-pflash0-storage"}
-blockdev {"driver":"file","filename":"/var/lib/libvirt/qemu/nvram/win10_VA=
RS.fd","node-name":"libvirt-pflash1-storage","auto-read-only":true,"discard=
":"unmap"}
-blockdev {"node-name":"libvirt-pflash1-format","read-only":false,"driver":=
"raw","file":"libvirt-pflash1-storage"}
-machine pc-q35-5.0,accel=3Dkvm,usb=3Doff,vmport=3Doff,dump-guest-core=3Dof=
f,mem-merge=3Doff,pflash0=3Dlibvirt-pflash0-format,pflash1=3Dlibvirt-pflash=
1-format
-cpu Skylake-Client-IBRS,ss=3Don,vmx=3Don,hypervisor=3Don,tsc-adjust=3Don,c=
lflushopt=3Don,umip=3Don,md-clear=3Don,stibp=3Don,arch-capabilities=3Don,ss=
bd=3Don,xsaves=3Don,pdpe1gb=3Don,ibpb=3Don,amd-ssbd=3Don,fma=3Doff,avx=3Dof=
f,f16c=3Doff,rdrand=3Doff,bmi1=3Doff,hle=3Doff,avx2=3Doff,bmi2=3Doff,rtm=3D=
off,rdseed=3Doff,adx=3Doff,hv-time,hv-relaxed,hv-vapic,hv-spinlocks=3D0x1ff=
f,hv-vpindex,hv-runtime,hv-synic,hv-stimer,hv-reset
-m 8192 -mem-prealloc -mem-path /dev/hugepages/libvirt/qemu/1-win10
-overcommit mem-lock=3Doff -smp 4,sockets=3D1,dies=3D1,cores=3D2,threads=3D=
2
-uuid 7ccc3031-1dab-4267-b72a-d60065b5ff7f -display none
-no-user-config -nodefaults -chardev
socket,id=3Dcharmonitor,fd=3D32,server,nowait -mon
chardev=3Dcharmonitor,id=3Dmonitor,mode=3Dcontrol -rtc
base=3Dlocaltime,driftfix=3Dslew -global kvm-pit.lost_tick_policy=3Ddelay
-no-hpet -no-shutdown -global ICH9-LPC.disable_s3=3D1 -global
ICH9-LPC.disable_s4=3D1 -boot menu=3Doff,strict=3Don -device
pcie-root-port,port=3D0x8,chassis=3D1,id=3Dpci.1,bus=3Dpcie.0,multifunction=
=3Don,addr=3D0x1
-device pcie-root-port,port=3D0x9,chassis=3D2,id=3Dpci.2,bus=3Dpcie.0,addr=
=3D0x1.0x1
-device pcie-root-port,port=3D0xa,chassis=3D3,id=3Dpci.3,bus=3Dpcie.0,addr=
=3D0x1.0x2
-device pcie-root-port,port=3D0xb,chassis=3D4,id=3Dpci.4,bus=3Dpcie.0,addr=
=3D0x1.0x3
-device pcie-pci-bridge,id=3Dpci.5,bus=3Dpci.2,addr=3D0x0 -device
qemu-xhci,id=3Dusb,bus=3Dpci.1,addr=3D0x0 -blockdev
{"driver":"host_device","filename":"/dev/disk/by-partuuid/05c3750b-060f-470=
3-95ea-6f5e546bf6e9","node-name":"libvirt-1-storage","cache":{"direct":fals=
e,"no-flush":true},"auto-read-only":true,"discard":"unmap"}
-blockdev {"node-name":"libvirt-1-format","read-only":false,"discard":"unma=
p","detect-zeroes":"unmap","cache":{"direct":false,"no-flush":true},"driver=
":"raw","file":"libvirt-1-storage"}
-device virtio-blk-pci,scsi=3Doff,bus=3Dpcie.0,addr=3D0xa,drive=3Dlibvirt-1=
-format,id=3Dvirtio-disk0,bootindex=3D1,write-cache=3Don
-netdev tap,fd=3D34,id=3Dhostnet0 -device
e1000,netdev=3Dhostnet0,id=3Dnet0,mac=3D52:54:00:c6:bb:bc,bus=3Dpcie.0,addr=
=3D0x3
-device ich9-intel-hda,id=3Dsound0,bus=3Dpcie.0,addr=3D0x4 -device
hda-duplex,id=3Dsound0-codec0,bus=3Dsound0.0,cad=3D0 -device
vfio-pci,host=3D0000:00:02.0,id=3Dhostdev0,bus=3Dpcie.0,addr=3D0x2,rombar=
=3D0
-device virtio-balloon-pci,id=3Dballoon0,bus=3Dpcie.0,addr=3D0x8 -object
rng-random,id=3Dobjrng0,filename=3D/dev/urandom -device
virtio-rng-pci,rng=3Dobjrng0,id=3Drng0,bus=3Dpcie.0,addr=3D0x9 -msg
timestamp=3Don

And I use libvirt 6.3.0 to manage the VM. Here's an xml of my VM.

<domain type=3D"kvm">
  <name>win10</name>
  <uuid>7ccc3031-1dab-4267-b72a-d60065b5ff7f</uuid>
  <metadata>
    <libosinfo:libosinfo
xmlns:libosinfo=3D"http://libosinfo.org/xmlns/libvirt/domain/1.0">
      <libosinfo:os id=3D"http://microsoft.com/win/10"/>
    </libosinfo:libosinfo>
  </metadata>
  <memory unit=3D"KiB">8388608</memory>
  <currentMemory unit=3D"KiB">8388608</currentMemory>
  <memoryBacking>
    <hugepages/>
    <nosharepages/>
  </memoryBacking>
  <vcpu placement=3D"static">4</vcpu>
  <cputune>
    <vcpupin vcpu=3D"0" cpuset=3D"0"/>
    <vcpupin vcpu=3D"1" cpuset=3D"2"/>
    <vcpupin vcpu=3D"2" cpuset=3D"1"/>
    <vcpupin vcpu=3D"3" cpuset=3D"3"/>
  </cputune>
  <os>
    <type arch=3D"x86_64" machine=3D"pc-q35-5.0">hvm</type>
    <loader readonly=3D"yes" type=3D"pflash">/usr/share/OVMF/OVMF_CODE.fd</=
loader>
    <nvram>/var/lib/libvirt/qemu/nvram/win10_VARS.fd</nvram>
    <boot dev=3D"hd"/>
    <bootmenu enable=3D"no"/>
  </os>
  <features>
    <acpi/>
    <apic/>
    <hyperv>
      <relaxed state=3D"on"/>
      <vapic state=3D"on"/>
      <spinlocks state=3D"on" retries=3D"8191"/>
      <vpindex state=3D"on"/>
      <runtime state=3D"on"/>
      <synic state=3D"on"/>
      <stimer state=3D"on"/>
      <reset state=3D"on"/>
    </hyperv>
    <vmport state=3D"off"/>
  </features>
  <cpu mode=3D"host-model" check=3D"partial">
    <topology sockets=3D"1" dies=3D"1" cores=3D"2" threads=3D"2"/>
  </cpu>
  <clock offset=3D"localtime">
    <timer name=3D"rtc" tickpolicy=3D"catchup"/>
    <timer name=3D"pit" tickpolicy=3D"delay"/>
    <timer name=3D"hpet" present=3D"no"/>
    <timer name=3D"hypervclock" present=3D"yes"/>
  </clock>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <pm>
    <suspend-to-mem enabled=3D"no"/>
    <suspend-to-disk enabled=3D"no"/>
  </pm>
  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type=3D"block" device=3D"disk">
      <driver name=3D"qemu" type=3D"raw" cache=3D"unsafe" discard=3D"unmap"
detect_zeroes=3D"unmap"/>
      <source dev=3D"/dev/disk/by-partuuid/05c3750b-060f-4703-95ea-6f5e546b=
f6e9"/>
      <target dev=3D"vda" bus=3D"virtio"/>
      <address type=3D"pci" domain=3D"0x0000" bus=3D"0x00" slot=3D"0x0a"
function=3D"0x0"/>
    </disk>
    <controller type=3D"pci" index=3D"0" model=3D"pcie-root"/>
    <controller type=3D"pci" index=3D"1" model=3D"pcie-root-port">
      <model name=3D"pcie-root-port"/>
      <target chassis=3D"1" port=3D"0x8"/>
      <address type=3D"pci" domain=3D"0x0000" bus=3D"0x00" slot=3D"0x01"
function=3D"0x0" multifunction=3D"on"/>
    </controller>
    <controller type=3D"pci" index=3D"2" model=3D"pcie-root-port">
      <model name=3D"pcie-root-port"/>
      <target chassis=3D"2" port=3D"0x9"/>
      <address type=3D"pci" domain=3D"0x0000" bus=3D"0x00" slot=3D"0x01"
function=3D"0x1"/>
    </controller>
    <controller type=3D"pci" index=3D"3" model=3D"pcie-root-port">
      <model name=3D"pcie-root-port"/>
      <target chassis=3D"3" port=3D"0xa"/>
      <address type=3D"pci" domain=3D"0x0000" bus=3D"0x00" slot=3D"0x01"
function=3D"0x2"/>
    </controller>
    <controller type=3D"pci" index=3D"4" model=3D"pcie-root-port">
      <model name=3D"pcie-root-port"/>
      <target chassis=3D"4" port=3D"0xb"/>
      <address type=3D"pci" domain=3D"0x0000" bus=3D"0x00" slot=3D"0x01"
function=3D"0x3"/>
    </controller>
    <controller type=3D"pci" index=3D"5" model=3D"pcie-to-pci-bridge">
      <model name=3D"pcie-pci-bridge"/>
      <address type=3D"pci" domain=3D"0x0000" bus=3D"0x02" slot=3D"0x00"
function=3D"0x0"/>
    </controller>
    <controller type=3D"usb" index=3D"0" model=3D"qemu-xhci">
      <address type=3D"pci" domain=3D"0x0000" bus=3D"0x01" slot=3D"0x00"
function=3D"0x0"/>
    </controller>
    <controller type=3D"sata" index=3D"0">
      <address type=3D"pci" domain=3D"0x0000" bus=3D"0x00" slot=3D"0x1f"
function=3D"0x2"/>
    </controller>
    <interface type=3D"network">
      <mac address=3D"52:54:00:c6:bb:bc"/>
      <source network=3D"default"/>
      <model type=3D"e1000"/>
      <address type=3D"pci" domain=3D"0x0000" bus=3D"0x00" slot=3D"0x03"
function=3D"0x0"/>
    </interface>
    <input type=3D"mouse" bus=3D"ps2"/>
    <input type=3D"keyboard" bus=3D"ps2"/>
    <sound model=3D"ich9">
      <address type=3D"pci" domain=3D"0x0000" bus=3D"0x00" slot=3D"0x04"
function=3D"0x0"/>
    </sound>
    <hostdev mode=3D"subsystem" type=3D"pci" managed=3D"yes">
      <source>
        <address domain=3D"0x0000" bus=3D"0x00" slot=3D"0x02" function=3D"0=
x0"/>
      </source>
      <rom bar=3D"off"/>
      <address type=3D"pci" domain=3D"0x0000" bus=3D"0x00" slot=3D"0x02"
function=3D"0x0"/>
    </hostdev>
    <memballoon model=3D"virtio">
      <address type=3D"pci" domain=3D"0x0000" bus=3D"0x00" slot=3D"0x08"
function=3D"0x0"/>
    </memballoon>
    <rng model=3D"virtio">
      <backend model=3D"random">/dev/urandom</backend>
      <address type=3D"pci" domain=3D"0x0000" bus=3D"0x00" slot=3D"0x09"
function=3D"0x0"/>
    </rng>
  </devices>
</domain>
